import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:scavenger_hunt_bingo/data/free_cards.dart';

import '../providers/settings_provider.dart';
import '../utils/size_config.dart';

class PaywallWidget extends StatefulWidget {
  final String title;
  final String description;
  final List<Package> packages;
  final ValueChanged<Package> onClickedPackage;
  final int index;
  const PaywallWidget(
      {Key? key,
      required this.title,
      required this.description,
      required this.packages,
      required this.onClickedPackage,
      required this.index})
      : super(key: key);

  @override
  State<PaywallWidget> createState() => _PaywallWidgetState();
}

class _PaywallWidgetState extends State<PaywallWidget> {
  @override
  Widget build(BuildContext context) {
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    final package = widget.packages[widget.index];

    final product = package.storeProduct;
    String storeTitle = product.title;
    String title = storeTitle.replaceAll(RegExp('\\(.*?\\)'), '');
    debugPrint("PaywallWidget buildPackage product: $product");
    debugPrint("entitlement: ${rcEntitlements[widget.index]}");
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 3),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          color: Colors.yellow[50]),
      constraints: SizeConfig.screenHeight > 750
          ? BoxConstraints(maxHeight: SizeConfig.blockSizeVertical * 75)
          : BoxConstraints(maxHeight: SizeConfig.blockSizeVertical * 95),
      child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeVertical * 5,
                      fontFamily: "CaveatBrush",
                      color: Colors.purple),
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.transparent, width: 1)),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent, width: 1),
                      ),
                      padding: SizeConfig.screenWidth > 500
                          ? EdgeInsets.symmetric(
                              horizontal: SizeConfig.blockSizeHorizontal * 15)
                          : EdgeInsets.symmetric(horizontal: 0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.blue, width: 2),
                            color: Colors.yellow[50]),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                            onTap: () => widget.onClickedPackage(package),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          title,
                                          style: TextStyle(
                                              color: Colors.purple,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  SizeConfig.blockSizeVertical *
                                                      2.5),
                                        ),
                                        Text(
                                          product.priceString,
                                          style: TextStyle(
                                              color: Colors.purple,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  SizeConfig.blockSizeVertical *
                                                      2.5),
                                        )
                                      ]),
                                ),
                                Text(
                                  product.description,
                                  style: TextStyle(
                                      color: Colors.purple,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 1.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                widget.index != 1
                    ? Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.transparent, width: 1)),
                        padding: SizeConfig.screenWidth > 500
                            ? EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockSizeHorizontal * 5)
                            : EdgeInsets.symmetric(
                                horizontal:
                                    SizeConfig.blockSizeHorizontal * 10),
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              CustomerInfo restoredInfo =
                                  await Purchases.restorePurchases();
                              // ... check restored purchaserInfo to see if entitlement is now active
                              debugPrint("RestoredInfo: $restoredInfo");

                              if (restoredInfo
                                  .entitlements
                                  .all[rcEntitlements[widget.index]]!
                                  .isActive) {
                                settingsProvider.setRemoveAds(true);
                              }
                            } on PlatformException catch (e) {
                              debugPrint("Error in restoring purchase: $e");
                            }
                            if (!mounted) return;
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Restore",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "$title",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          SizeConfig.safeBlockVertical * 2.5),
                                ),
                                Text(
                                  "Purchase",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
                const SizedBox(
                  height: 16,
                )
              ],
            ),
          )),
    );
  }
}
