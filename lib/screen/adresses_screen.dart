import 'package:WeServeU/model/address_model.dart';
import 'package:WeServeU/screen/add_address_screen.dart';
import 'package:WeServeU/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/address_provider.dart';

class AddressListScreen extends StatelessWidget {
  const AddressListScreen({Key? key}) : super(key: key);
  static const routeName = '/address-list';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var local=AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title:  Text(local.shippingAddress),
        backgroundColor: Color(0xff5e7af3),
      ),
      body: Consumer<AddressProvider>(builder: (context, provider, _) {
        return ListView(
          children: provider.addressList
              .map((e) => AddressUnit(addressModel: e))
              .toList(),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Provider.of<AddressProvider>(context, listen: false)
              .addressModel = null;
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return const AddAddressScreen();
          }));
        },
        label: Text(local.newString),
        icon: const Icon(Icons.location_city),
      ),
    );
  }
}

class AddressUnit extends StatelessWidget {
  final bool selection;
  const AddressUnit({Key? key, required this.addressModel,   this.selection=false}) : super(key: key);

  final AddressModel addressModel;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var local=AppLocalizations.of(context);
    final provider = Provider.of<AddressProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MyCustomCard(
        elevation: 1.0,
        radius: 16,
        margin: 2,
        padding: 8,
        color: Color(0xffb3d6ff),
        child: Stack(
          children: [
            Column(
              children: [
                MySubTitle(text: '${local.floorNo} ${addressModel.floorno}, ${local.aptno} : ${addressModel.appartmentno}'),
                MySubTitle(text: '${addressModel.buildingName}'),
                MySubTitle(text: '${addressModel.area}'),
                MySubTitle(text: '${addressModel.line1}'),
                MySubTitle(text: '${addressModel.line2}'),
                MySubTitle(text: '${addressModel.phone}'),
                MySubTitle(
                    text:
                        '${addressModel.city},${addressModel.state},${addressModel.postalCode},${addressModel.countryCode}'),
              ],
            ),
            Positioned(
                top: 0,
                right: 0,
                child: Visibility(
                  visible: selection,
                  child: Radio(
                      value: addressModel.key!,
                      groupValue: provider.addressModel?.key,
                      onChanged: (v) {
                        provider.setAddressModel(addressModel);
                      }),
                )),
            Positioned(
                top: 0,
                right: 0,
                child: Visibility(
                  visible: !selection,
                  child: IconButton(
                      onPressed: () {
                        Provider.of<AddressProvider>(context, listen: false)
                            .addressModel = addressModel;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => AddAddressScreen()));
                      },
                      icon: Image.asset('assets/edit.png')),
                )),
            Positioned(
                bottom: 0,
                right: 0,
                child: Visibility(
                  visible: !selection,
                  child: IconButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: true,
                          // false = user must tap button, true = tap outside dialog
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: Text(local.confirm),
                              content: Text(local.areyousuretodelete),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(local.no),
                                  onPressed: () {
                                    Navigator.of(dialogContext)
                                        .pop(); // Dismiss alert dialog
                                  },
                                ),
                                TextButton(
                                  child: Text(local.yes),
                                  onPressed: () {
                                    Navigator.of(dialogContext)
                                        .pop(); // Dismiss alert dialog
                                    Provider.of<AddressProvider>(dialogContext,
                                            listen: false)
                                        .delete(addressModel.key!);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.delete_forever_outlined)),
                )),
          ],
        ),
      ),
    );
  }
}
