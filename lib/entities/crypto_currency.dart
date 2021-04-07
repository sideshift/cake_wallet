import 'package:cake_wallet/entities/enumerable_item.dart';
import 'package:hive/hive.dart';

part 'crypto_currency.g.dart';

@HiveType(typeId: 0)
class CryptoCurrency extends EnumerableItem<int> with Serializable<int> {
  const CryptoCurrency({final String title, final int raw})
      : super(title: title, raw: raw);

  static const all = [
    CryptoCurrency.xmr,
    CryptoCurrency.ada,
    CryptoCurrency.bch,
    CryptoCurrency.bnb,
    CryptoCurrency.bsv,
    CryptoCurrency.btc,
    CryptoCurrency.btcLiquid,
    CryptoCurrency.btcPayjoin,
    CryptoCurrency.comp,
    CryptoCurrency.dai,
    CryptoCurrency.dash,
    CryptoCurrency.doge,
    CryptoCurrency.eth,
    CryptoCurrency.flexUsd,
    CryptoCurrency.ftt,
    CryptoCurrency.ltc,
    CryptoCurrency.nano,
    CryptoCurrency.srm,
    CryptoCurrency.sushi,
    CryptoCurrency.trx,
    CryptoCurrency.usdt,
    CryptoCurrency.usdterc20,
    CryptoCurrency.uni,
    CryptoCurrency.usdc,
    CryptoCurrency.usdh,
    CryptoCurrency.usdt,
    CryptoCurrency.usdtBCH,
    CryptoCurrency.usdterc20,
    CryptoCurrency.usdtLiquid,
    CryptoCurrency.wbtc,
    CryptoCurrency.xai,
    CryptoCurrency.xaut,
    CryptoCurrency.xlm,
    CryptoCurrency.xrp,
    CryptoCurrency.xtz,
    CryptoCurrency.yfi,
    CryptoCurrency.zec,
    CryptoCurrency.zecShielded,
  ];

  static const changeNow = [
    CryptoCurrency.xmr,
    CryptoCurrency.ada,
    CryptoCurrency.bch,
    CryptoCurrency.bnb,
    CryptoCurrency.btc,
    CryptoCurrency.dai,
    CryptoCurrency.dash,
    CryptoCurrency.eos,
    CryptoCurrency.eth,
    CryptoCurrency.ltc,
    CryptoCurrency.nano,
    CryptoCurrency.trx,
    CryptoCurrency.usdt,
    CryptoCurrency.usdterc20,
    CryptoCurrency.xlm,
    CryptoCurrency.xrp
  ];

  static const sideshift = [
    CryptoCurrency.xmr,
    CryptoCurrency.bch,
    CryptoCurrency.bnb,
    CryptoCurrency.bsv,
    CryptoCurrency.btc,
    CryptoCurrency.btcLiquid,
    CryptoCurrency.btcPayjoin,
    CryptoCurrency.comp,
    CryptoCurrency.dai,
    CryptoCurrency.dash,
    CryptoCurrency.doge,
    CryptoCurrency.eth,
    CryptoCurrency.flexUsd,
    CryptoCurrency.ftt,
    CryptoCurrency.ltc,
    CryptoCurrency.srm,
    CryptoCurrency.sushi,
    CryptoCurrency.uni,
    CryptoCurrency.usdc,
    CryptoCurrency.usdh,
    CryptoCurrency.usdt,
    CryptoCurrency.usdtBCH,
    CryptoCurrency.usdterc20,
    CryptoCurrency.usdtLiquid,
    CryptoCurrency.wbtc,
    CryptoCurrency.xai,
    CryptoCurrency.xaut,
    CryptoCurrency.xtz,
    CryptoCurrency.xlm,
    CryptoCurrency.yfi,
    CryptoCurrency.zec,
    CryptoCurrency.zecShielded,
  ];

  static const xmr = CryptoCurrency(title: 'XMR', raw: 0);
  static const ada = CryptoCurrency(title: 'ADA', raw: 1);
  static const bch = CryptoCurrency(title: 'BCH', raw: 2);
  static const bnb = CryptoCurrency(title: 'BNB', raw: 3);
  static const bsv = CryptoCurrency(title: 'BSV', raw: 4);
  static const btc = CryptoCurrency(title: 'BTC', raw: 5);
  static const btcLiquid = CryptoCurrency(title: 'BTCLIQUID', raw: 6);
  static const btcPayjoin = CryptoCurrency(title: 'BTCPAYJOIN', raw: 7);
  static const comp = CryptoCurrency(title: 'COMP', raw: 8);
  static const dai = CryptoCurrency(title: 'DAI', raw: 9);
  static const dash = CryptoCurrency(title: 'DASH', raw: 10);
  static const doge = CryptoCurrency(title: 'DOGE', raw: 11);
  static const eos = CryptoCurrency(title: 'EOS', raw: 12);
  static const eth = CryptoCurrency(title: 'ETH', raw: 13);
  static const flexUsd = CryptoCurrency(title: 'FLEXUSD', raw: 14);
  static const ftt = CryptoCurrency(title: 'FTT', raw: 15);
  static const ltc = CryptoCurrency(title: 'LTC', raw: 16);
  static const nano = CryptoCurrency(title: 'NANO', raw: 17);
  static const srm = CryptoCurrency(title: 'SRM', raw: 18);
  static const sushi = CryptoCurrency(title: 'SUSHI', raw: 19);
  static const trx = CryptoCurrency(title: 'TRX', raw: 20);
  static const uni = CryptoCurrency(title: 'UNI', raw: 21);
  static const usdc = CryptoCurrency(title: 'USDC', raw: 22);
  static const usdh = CryptoCurrency(title: 'USDH', raw: 23);
  static const usdt = CryptoCurrency(title: 'USDTOMNI', raw: 24);
  static const usdtBCH = CryptoCurrency(title: 'USDTBCH', raw: 25);
  static const usdterc20 = CryptoCurrency(title: 'USDTERC20', raw: 26);
  static const usdtLiquid = CryptoCurrency(title: 'USDTLIQUID', raw: 27);
  static const wbtc = CryptoCurrency(title: 'WBTC', raw: 28);
  static const xai = CryptoCurrency(title: 'XAI', raw: 29);
  static const xaut = CryptoCurrency(title: 'XAUT', raw: 30);
  static const xlm = CryptoCurrency(title: 'XLM', raw: 31);
  static const xrp = CryptoCurrency(title: 'XRP', raw: 32);
  static const xtz = CryptoCurrency(title: 'XTZ', raw: 33);
  static const yfi = CryptoCurrency(title: 'YFI', raw: 34);
  static const zec = CryptoCurrency(title: 'ZEC', raw: 35);
  static const zecShielded = CryptoCurrency(title: 'ZECSHIELD', raw: 36);

  static CryptoCurrency deserialize({int raw}) {
    switch (raw) {
      case 0:
        return CryptoCurrency.xmr;
      case 1:
        return CryptoCurrency.ada;
      case 2:
        return CryptoCurrency.bch;
      case 3:
        return CryptoCurrency.bnb;
      case 4:
        return CryptoCurrency.bsv;
      case 5:
        return CryptoCurrency.btc;
      case 6:
        return CryptoCurrency.btcLiquid;
      case 7:
        return CryptoCurrency.btcPayjoin;
      case 8:
        return CryptoCurrency.comp;
      case 9:
        return CryptoCurrency.dai;
      case 10:
        return CryptoCurrency.dash;
      case 11:
        return CryptoCurrency.doge;
      case 12:
        return CryptoCurrency.eos;
      case 13:
        return CryptoCurrency.eth;
      case 14:
        return CryptoCurrency.flexUsd;
      case 15:
        return CryptoCurrency.ftt;
      case 16:
        return CryptoCurrency.ltc;
      case 17:
        return CryptoCurrency.nano;
      case 18:
        return CryptoCurrency.srm;
      case 19:
        return CryptoCurrency.sushi;
      case 20:
        return CryptoCurrency.trx;
      case 21:
        return CryptoCurrency.uni;
      case 22:
        return CryptoCurrency.usdc;
      case 23:
        return CryptoCurrency.usdh;
      case 24:
        return CryptoCurrency.usdt;
      case 25:
        return CryptoCurrency.usdtBCH;
      case 26:
        return CryptoCurrency.usdterc20;
      case 27:
        return CryptoCurrency.usdtLiquid;
      case 28:
        return CryptoCurrency.wbtc;
      case 29:
        return CryptoCurrency.xai;
      case 30:
        return CryptoCurrency.xaut;
      case 31:
        return CryptoCurrency.xlm;
      case 32:
        return CryptoCurrency.xrp;
      case 33:
        return CryptoCurrency.xtz;
      case 34:
        return CryptoCurrency.yfi;
      case 35:
        return CryptoCurrency.zec;
      case 36:
        return CryptoCurrency.zecShielded;
      default:
        return null;
    }
  }

  static CryptoCurrency fromString(String raw) {
    switch (raw.toLowerCase()) {
      case 'xmr':
        return CryptoCurrency.xmr;
      case 'ada':
        return CryptoCurrency.ada;
      case 'bch':
        return CryptoCurrency.bch;
      case 'bnb':
        return CryptoCurrency.bnb;
      case 'bsv':
        return CryptoCurrency.bsv;
      case 'btc':
        return CryptoCurrency.btc;
      case 'btcliquid':
      case 'liquid':
        return CryptoCurrency.btcLiquid;
      case 'btcpayjoin':
      case 'payjoin':
        return CryptoCurrency.btcPayjoin;
      case 'comp':
        return CryptoCurrency.comp;
      case 'dai':
        return CryptoCurrency.dai;
      case 'dash':
        return CryptoCurrency.dash;
      case 'doge':
        return CryptoCurrency.doge;
      case 'eos':
        return CryptoCurrency.eos;
      case 'eth':
        return CryptoCurrency.eth;
      case 'flexusd':
        return CryptoCurrency.flexUsd;
      case 'ftt':
        return CryptoCurrency.ftt;
      case 'ltc':
        return CryptoCurrency.ltc;
      case 'nano':
        return CryptoCurrency.nano;
      case 'srm':
        return CryptoCurrency.srm;
      case 'sushi':
        return CryptoCurrency.sushi;
      case 'trx':
        return CryptoCurrency.trx;
      case 'uni':
        return CryptoCurrency.uni;
      case 'usdc':
        return CryptoCurrency.usdc;
      case 'usdh':
        return CryptoCurrency.usdh;
      case 'usdt':
        return CryptoCurrency.usdt;
      case 'usdtbch':
        return CryptoCurrency.usdtBCH;
      case 'usdterc20':
        return CryptoCurrency.usdterc20;
      case 'usdtliquid':
      case 'usdtla':
        return CryptoCurrency.usdtLiquid;
      case 'wbtc':
        return CryptoCurrency.wbtc;
      case 'xai':
        return CryptoCurrency.xai;
      case 'xaut':
        return CryptoCurrency.xaut;
      case 'xlm':
        return CryptoCurrency.xlm;
      case 'xrp':
        return CryptoCurrency.xrp;
      case 'xtz':
        return CryptoCurrency.xtz;
      case 'yfi':
        return CryptoCurrency.yfi;
      case 'zec':
        return CryptoCurrency.zec;
      case 'zecshielded':
      case 'zaddr':
        return CryptoCurrency.zecShielded;
      default:
        return null;
    }
  }

  @override
  String toString() => title;
}
