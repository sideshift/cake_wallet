import 'package:cake_wallet/entities/order.dart';
import 'package:cake_wallet/store/settings_store.dart';
import 'package:cake_wallet/view_model/dashboard/action_list_item.dart';
import 'package:cake_wallet/entities/balance_display_mode.dart';

class OrderListItem extends ActionListItem {
  OrderListItem({this.order, this.settingsStore});

  final Order order;
  final SettingsStore settingsStore;

  BalanceDisplayMode get displayMode => settingsStore.balanceDisplayMode;

  String get orderFormattedAmount {
    return order.amount != null
        ? displayMode == BalanceDisplayMode.hiddenBalance
          ? '---'
          : order.amountFormatted()
        : order.amount;
  }

  @override
  DateTime get date => order.createdAt;
}