import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scavenger_hunt_bingo/intro.dart';

List<String> testDeviceIDs = [
  "8E3C44E0453B296DEDFBA106CDBB59CC", // Samsung S5
  "B23BF33B20AC43239D05001A504F0EF3", //iPhone8 13.0
  "77D59CAC6A854490B6A389C9B5531A12", //iPhone13 mini 15.0
  "ea230aa9edfec099faea521e541b8502", //my phone
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize().then((InitializationStatus status) {
    print('Initialization done: ${status.adapterStatuses}');
  });

  final RequestConfiguration requestConfiguration = RequestConfiguration(
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
      testDeviceIds: testDeviceIDs);
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  runApp(ScavengerBingo());
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
        primarySwatch:
            Colors.purple, //i am set brown colour,you can set your colour here
      ),
      home: IntroPage(),
    );
  }
}
