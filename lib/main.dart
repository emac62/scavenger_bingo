import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scavenger_hunt_bingo/data/bingo_card.dart';
import 'package:scavenger_hunt_bingo/pages/settings.dart';

import 'package:scavenger_hunt_bingo/providers/settings_provider.dart';
import 'package:scavenger_hunt_bingo/widgets/purchase_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/intro.dart';
import 'providers/controller.dart';

List<String> testDeviceIDs = [
  "B23BF33B20AC43239D05001A504F0EF3", //iPhone8 13.0
  "77D59CAC6A854490B6A389C9B5531A12", //iPhone13 mini 15.0
  "ea230aa9edfec099faea521e541b8502", //my phone
  "4520409bc3ffb536b6e203bf9d0b0007", //old SE
  "8f4cb8307ba6019ca82bccc419afe5d0", // my iPad
  "B148F45EC4D7035147769503E195ECF9", //Lenovo
];

bool useTestAds = false;
bool showBannerAd = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sp = await SharedPreferences.getInstance();
  bool removeAds = sp.getBool("removeAds") ?? false;
  debugPrint("removeAds: $removeAds");

  if (!removeAds) {
    MobileAds.instance.initialize();
    final RequestConfiguration requestConfiguration = RequestConfiguration(
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
        testDeviceIds: useTestAds ? testDeviceIDs : null);
    MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  }

  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await PurchaseApi.init();

  await Hive.initFlutter();
  Hive.registerAdapter(BingoCardAdapter());
  await Hive.openBox<BingoCard>("cards");
  // debugRepaintRainbowEnabled = true;
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ChangeNotifierProvider(create: (_) => Controller())
    ],
    child: ScavengerBingo(),
  ));
}

class ScavengerBingo extends StatefulWidget {
  const ScavengerBingo({Key? key}) : super(key: key);

  @override
  _ScavengerBingoState createState() => _ScavengerBingoState();
}

class _ScavengerBingoState extends State<ScavengerBingo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.yellow[50],
        primarySwatch:
            Colors.purple, //i am set brown colour,you can set your colour here
      ),
      home: IntroPage(),
      routes: {
        "/settings": (BuildContext context) => SettingsPage(),
      },
    );
  }
}
