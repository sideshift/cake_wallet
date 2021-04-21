import 'package:cake_wallet/entities/balance.dart';
import 'package:mobx/mobx.dart';
import 'package:cake_wallet/core/wallet_base.dart';
import 'package:cake_wallet/store/wallet_list_store.dart';
import 'package:cake_wallet/store/authentication_store.dart';
import 'package:cake_wallet/store/settings_store.dart';
import 'package:cake_wallet/store/node_list_store.dart';

part 'app_store.g.dart';

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  AppStoreBase(
      {this.authenticationStore,
      this.walletList,
      this.settingsStore,
      this.nodeListStore});

  AuthenticationStore authenticationStore;

  @observable
  WalletBase<Balance> wallet;

  WalletListStore walletList;

  SettingsStore settingsStore;

  NodeListStore nodeListStore;

  @action
  void changeCurrentWallet(WalletBase<Balance> wallet) {
    this.wallet?.close();
    this.wallet = wallet;
  }
}
