import 'dart:io';

import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  static const gApiKey = 'goog_OOlaoNLSIHfjyFmozJfGvEMlKgK';
  static const aApiKey = 'appl_KPtAHawJKsmcEdCtjoKmQcmVXgb';

  static Future init() async {
    await Purchases.setLogLevel(LogLevel.debug);

    late PurchasesConfiguration configuration;

    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(gApiKey);
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(aApiKey);
    }
    await Purchases.configure(configuration);
  }
}
