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
import 'package:cake_wallet/exchange/changenow/changenow_request.dart';
import 'package:cake_wallet/exchange/exchange_provider_description.dart';
import 'package:cake_wallet/exchange/trade_not_created_exeption.dart';

class PairsResponse {
  double min;
  double max;
  double rate;
}

class SideShiftError {
  String message;
}

class QuoteResponse {
  String createdAt;
  double depositAmount;
  String depositMethod;
  String expiresAt;
  String id;
  double rate;
  double settleAmount;
  String settleMethod;
  SideShiftError error;
}

class SideShiftAddress {
  String address;
  String memo;
}

class SideShiftTx {
  String type;
  String txHash;
  String ledgerId;
}

class SideShiftDeposit {
  int createdAt;
  String createdAtISO;
  String depositAmount;
  SideShiftTx depositTx;
  String depositId;
  String status;
  SideShiftAddress refundAddress;
  SideShiftTx refundTx;
  double settleAmount;
  double settleRate;
  SideShiftTx settleTx;
  String orderId;
}

class OrderResponse {
  int createdAt;
  String createdAtISO;
  String expiresAt;
  String expiresAtISO;
  SideShiftAddress depositAddress;
  String depositMethodId;
  String id;
  String orderId;
  SideShiftAddress settleAddress;
  String settleMethodId;
  double depositMax;
  double depositMin;
  String quoteId;
  String settleAmount;
  String depositAmount;
  SideShiftError error;
  List<SideShiftDeposit> deposits;
}

class SideShiftExchangeProvider extends ExchangeProvider {
  SideShiftExchangeProvider()
      : super(
      pairList: CryptoCurrency.all
          .map((i) =>
          CryptoCurrency.all
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
    final symbol = from.toString().toLowerCase() + '/' + to.toString().toLowerCase();
    final url = apiUri + _pairsSuffix + symbol;

    final response = await get(url);
    final responseJSON = json.decode(response.body) as PairsResponse;

    return Limits(min: responseJSON.min, max: responseJSON.max);
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

      final quoteResponse = await post(
          quoteUrl, headers: {'Content-Type': 'application/json'},
          body: json.encode(quoteBody));

      final quoteResponseJSON = json.decode(
          quoteResponse.body) as QuoteResponse;

      if (quoteResponse.statusCode != 200) {
        if (quoteResponse.statusCode == 400) {
          final error = quoteResponseJSON.error.message;

          throw TradeNotCreatedException(description, description: error);
        }

        throw TradeNotCreatedException(description);
      }

      final fixedOrderBody = {
        "type": "fixed",
        "quoteId": quoteResponseJSON.id,
        "settleAddress": _request.settleAddress
      };

      final fixedOrderResponse = await post(
          orderUrl, headers: {'Content-Type': 'application/json'},
          body: json.encode(fixedOrderBody));

      final fixedOrderResponseJSON = json.decode(
          fixedOrderResponse.body) as OrderResponse;

      if (fixedOrderResponse.statusCode != 200) {
        if (fixedOrderResponse.statusCode == 400) {
          final error = fixedOrderResponseJSON.error.message;

          throw TradeNotCreatedException(description, description: error);
        }

        throw TradeNotCreatedException(description);
      }

      return Trade(
          id: fixedOrderResponseJSON.id,
          from: _request.depositMethod,
          to: _request.settleMethod,
          provider: description,
          inputAddress: fixedOrderResponseJSON.depositAddress.address,
          refundAddress: _request.refundAddress,
          createdAt: DateTime.now(),
          state: TradeState.created
      );
    } else {
      final variableOrderBody = {
        "type": "variable",
        "depositMethodId": _request.depositMethod,
        "settleMethodId": _request.settleMethod,
        "settleAddress": _request.settleAddress,
        "affiliateId": secrets.sideShiftAccountId
      };

      final variableOrderResponse = await post(
          orderUrl, headers: {'Content-Type': 'application/json'},
          body: json.encode(variableOrderBody));

      final variableOrderResponseJSON = json.decode(
          variableOrderResponse.body) as OrderResponse;

      if (variableOrderResponse.statusCode != 200) {
        if (variableOrderResponse.statusCode == 400) {
          final error = variableOrderResponseJSON.error.message;

          throw TradeNotCreatedException(description, description: error);
        }

        throw TradeNotCreatedException(description);
      }

      return Trade(
          id: variableOrderResponseJSON.id,
          from: _request.depositMethod,
          to: _request.settleMethod,
          provider: description,
          inputAddress: variableOrderResponseJSON.depositAddress.address,
          refundAddress: _request.refundAddress,
          createdAt: DateTime.now(),
          state: TradeState.created
      );
    }
  }

  @override
  Future<Trade> findTradeById({@required String id}) async {
    final url = apiUri + _orderSuffix + '/' + id;
    final response = await get(url);

    final responseJSON = json.decode(response.body) as OrderResponse;

    if (response.statusCode != 200) {
      if (response.statusCode == 400) {
        final error = responseJSON.error.message;

        throw TradeNotFoundException(id,
            provider: description, description: error);
      }

      throw TradeNotFoundException(id, provider: description);
    }

    final expiredAt =
    responseJSON.expiresAt != null ? DateTime.parse(responseJSON.expiresAt)
        .toLocal() : null;

    return Trade(
        id: id,
        from: CryptoCurrency.fromString(responseJSON.depositMethodId),
        to: CryptoCurrency.fromString(responseJSON.settleMethodId),
        provider: description,
        inputAddress: responseJSON.depositAddress.address,
        amount: responseJSON.deposits[0].depositAmount,
        state: TradeState.deserialize(raw: responseJSON.deposits[0].status),
        expiredAt: expiredAt,
        outputTransaction: responseJSON.deposits[0].settleTx.txHash
    );
  }

  @override
  Future<double> calculateAmount({CryptoCurrency from,
    CryptoCurrency to,
    double amount,
    bool isFixedRateMode,
    bool isReceiveAmount}) async {
    final url = apiUri + _pairsSuffix + from.toString().toLowerCase() + '/' + to.toString().toLowerCase();

    final response = await get(url);

    final responseJSON = json.decode(response.body) as PairsResponse;

    final estimatedAmount = amount / responseJSON.rate;

    return estimatedAmount;
  }

}
