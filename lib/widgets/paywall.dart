import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../providers/settings_provider.dart';
import '../utils/size_config.dart';

class PaywallWidget extends StatefulWidget {
  final String title;
  final String description;
  final List<Package> packages;
  final ValueChanged<Package> onClickedPackage;
  const PaywallWidget(
      {Key? key,
      required this.title,
      required this.description,
      required this.packages,
      required this.onClickedPackage})
      : super(key: key);

  @override
  State<PaywallWidget> createState() => _PaywallWidgetState();
}

class _PaywallWidgetState extends State<PaywallWidget> {
  @override
  Widget build(BuildContext context) {
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    Widget buildPackage(BuildContext context, Package package) {
      final product = package.storeProduct;
      debugPrint("package: $product");
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent, width: 1),
        ),
        padding: SizeConfig.screenWidth > 500
            ? EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 15)
            : EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 10),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Remove Ads",
                            style: TextStyle(
                                color: Colors.purple,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.blockSizeVertical * 2.5),
                          ),
                          Text(
                            product.priceString,
                            style: TextStyle(
                                color: Colors.purple,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.blockSizeVertical * 2.5),
                          )
                        ]),
                  ),
                  Text(
                    product.description,
                    style: TextStyle(
                        color: Colors.purple,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockSizeVertical * 1.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget buildPackages() {
      return MediaQuery.removePadding(
        removeBottom: true,
        context: context,
        child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: widget.packages.length,
            itemBuilder: (context, index) {
              final package = widget.packages[index];
              return buildPackage(context, package);
            }),
      );
    }

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
                  widget.title,
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
                    child: buildPackages()),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent, width: 1)),
                  padding: SizeConfig.screenWidth > 500
                      ? EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 15)
                      : EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        CustomerInfo restoredInfo =
                            await Purchases.restorePurchases();
                        // ... check restored purchaserInfo to see if entitlement is now active
                        debugPrint("RestoredInfo: $restoredInfo");
                        if (restoredInfo.entitlements.all['no_ads']!.isActive) {
                          settingsProvider.setRemoveAds(true);
                        }
                      } on PlatformException catch (e) {
                        debugPrint("Error in restoring purchase: $e");
                      }
                      if (!mounted) return;
                      Navigator.pop(context);
                    },
                    child: const Text("Restore Remove Ads Purchase"),
                  ),
                ),
                const SizedBox(
                  height: 16,
                )
              ],
            ),
          )),
    );
  }
}
