import 'dart:convert';
import 'package:cake_wallet/exchange/sideshift/sideshift_request.dart';
import 'package:cake_wallet/exchange/trade_not_found_exeption.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:cake_wallet/.secrets.g.dart' as secrets;
import 'package:cake_wallet/entities/crypto_currency.dart';
import 'package:cake_wallet/exchange/exchange_pair.dart';
import 'package:cake_wallet/exchange/exchange_provider.dart';
import 'package:cake_wallet/exchange/limits.dart';
import 'package:cake_wallet/exchange/trade.dart';
import 'package:cake_wallet/exchange/trade_request.dart';
import 'package:cake_wallet/exchange/trade_state.dart';
import 'package:cake_wallet/exchange/exchange_provider_description.dart';
import 'package:cake_wallet/exchange/trade_not_created_exeption.dart';

class SideShiftExchangeProvider extends ExchangeProvider {
  SideShiftExchangeProvider()
      : super(
            pairList: CryptoCurrency.all
                .map((i) => CryptoCurrency.all
                    .map((k) => ExchangePair(from: i, to: k, reverse: true))
                    .where((c) => c != null))
                .expand((i) => i)
                .toList());

  static const apiUri = 'https://sideshift.ai/api/v1';
  static const accountId = secrets.sideShiftAccountId;
  static const _pairsSuffix = '/pairs/';
  static const _quoteSuffix = '/quotes';
  static const _orderSuffix = '/orders';

  @override
  String get title => 'SideShift.ai';

  @override
  bool get isAvailable => true;

  @override
  ExchangeProviderDescription get description =>
      ExchangeProviderDescription.sideShift;

  @override
  Future<bool> checkIsAvailable() async => true;

  @override
  Future<Limits> fetchLimits(
      {CryptoCurrency from, CryptoCurrency to, bool isFixedRateMode}) async {
    final symbol =
        from.toString().toLowerCase() + '/' + to.toString().toLowerCase();
    final url = apiUri + _pairsSuffix + symbol;

    final response = await get(url);
    final responseJSON = json.decode(response.body) as Map<String, dynamic>;
    final min = responseJSON["min"] as String;
    final max = responseJSON["max"] as String;

    return Limits(min: double.parse(min), max: double.parse(max));
  }

  @override
  Future<Trade> createTrade(
      {TradeRequest request, bool isFixedRateMode}) async {
    final orderUrl = apiUri + _orderSuffix;
    final _request = request as SideShiftRequest;

    if (isFixedRateMode) {
      final quoteUrl = apiUri + _quoteSuffix;

      final quoteBody = {
        'depositMethod': _request.depositMethod,
        'settleMethod': _request.settleMethod,
        'depositAmount': _request.depositAmount
      };

      final quoteResponse = await post(quoteUrl,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(quoteBody));

      if (quoteResponse.statusCode != 200) {
        if (quoteResponse.statusCode == 400) {
          final quoteResponseJSON =
              json.decode(quoteResponse.body) as Map<String, dynamic>;
          final errorMessage = quoteResponseJSON["error"]["message"] as String;

          throw TradeNotCreatedException(description,
              description: errorMessage);
        }

        throw TradeNotCreatedException(description);
      }

      final quoteResponseJSON =
          json.decode(quoteResponse.body) as Map<String, dynamic>;

      final fixedOrderBody = {
        "type": "fixed",
        "quoteId": quoteResponseJSON["id"] as String,
        "settleAddress": _request.settleAddress
      };

      final fixedOrderResponse = await post(orderUrl,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(fixedOrderBody));

      if (fixedOrderResponse.statusCode != 200) {
        if (fixedOrderResponse.statusCode == 400) {
          final fixedOrderResponseJSON =
              json.decode(fixedOrderResponse.body) as Map<String, dynamic>;
          final error = fixedOrderResponseJSON["error"]["message"] as String;

          throw TradeNotCreatedException(description, description: error);
        }

        throw TradeNotCreatedException(description);
      }

      final fixedOrderResponseJSON =
          json.decode(fixedOrderResponse.body) as Map<String, dynamic>;

      return Trade(
          id: fixedOrderResponseJSON["id"] as String,
          from: _request.depositMethod,
          to: _request.settleMethod,
          provider: description,
          inputAddress:
              fixedOrderResponseJSON["depositAddress"]["address"] as String,
          refundAddress: _request.refundAddress,
          createdAt: DateTime.now(),
          state: TradeState.created);
    } else {
      final variableOrderBody = {
        "type": "variable",
        "depositMethodId": _request.depositMethod,
        "settleMethodId": _request.settleMethod,
        "settleAddress": _request.settleAddress,
        "affiliateId": secrets.sideShiftAccountId
      };

      final variableOrderResponse = await post(orderUrl,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(variableOrderBody));

      if (variableOrderResponse.statusCode != 200) {
        if (variableOrderResponse.statusCode == 400) {
          final variableOrderResponseJSON =
              json.decode(variableOrderResponse.body) as Map<String, dynamic>;
          final error = variableOrderResponseJSON["error"]["message"] as String;

          throw TradeNotCreatedException(description, description: error);
        }

        throw TradeNotCreatedException(description);
      }

      final variableOrderResponseJSON =
          json.decode(variableOrderResponse.body) as Map<String, dynamic>;

      final id = variableOrderResponseJSON["id"] as String;
      final inputAddress =
          variableOrderResponseJSON["depositAddress"]["address"] as String;

      return Trade(
          id: id,
          from: _request.depositMethod,
          to: _request.settleMethod,
          provider: description,
          inputAddress: inputAddress,
          refundAddress: _request.refundAddress,
          createdAt: DateTime.now(),
          state: TradeState.created);
    }
  }

  @override
  Future<Trade> findTradeById({@required String id}) async {
    final url = apiUri + _orderSuffix + '/' + id;
    final response = await get(url);

    if (response.statusCode != 200) {
      if (response.statusCode == 400) {
        final responseJSON = json.decode(response.body) as Map<String, dynamic>;
        final error = responseJSON["error"]["message"] as String;

        throw TradeNotFoundException(id,
            provider: description, description: error);
      }

      throw TradeNotFoundException(id, provider: description);
    }
    print('fasz');
    final responseJSON = json.decode(response.body) as Map<String, dynamic>;

    final expiredAt = responseJSON["expiresAt"] != null
        ? DateTime.parse(responseJSON["expiresAt"] as String).toLocal()
        : null;

    final depositMethodId = responseJSON["depositMethodId"] as String;
    final from = CryptoCurrency.fromString(depositMethodId);
    final settleMethodId = responseJSON["settleMethodId"] as String;
    final to = CryptoCurrency.fromString(settleMethodId);
    final inputAddress = responseJSON["depositAddress"]["address"] as String;
    final amount = responseJSON["deposits"][0]["depositAmount"] as String;
    final state = responseJSON["deposits"][0]["status"] as String;
    final outputTransaction =
        responseJSON["deposits"][0]["settleTx"]["txHash"] as String;

    return Trade(
      id: id,
      from: from,
      to: to,
      provider: description,
      inputAddress: inputAddress,
      amount: amount,
      state: TradeState.deserialize(raw: state),
      expiredAt: expiredAt,
      outputTransaction: outputTransaction,
    );
  }

  @override
  Future<double> calculateAmount(
      {CryptoCurrency from,
      CryptoCurrency to,
      final double amount,
      bool isFixedRateMode,
      bool isReceiveAmount}) async {
    final url = apiUri +
        _pairsSuffix +
        to.toString().toLowerCase() +
        '/' +
        from.toString().toLowerCase();

    final response = await get(url);

    final responseJSON = json.decode(response.body) as Map<String, dynamic>;
    final rate = responseJSON['rate'] as String;

    final estimatedAmount = amount / double.parse(rate);

    return estimatedAmount;
  }
}
