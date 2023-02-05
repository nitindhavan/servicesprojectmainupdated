import 'package:WeServeU/data/constants.dart';
import 'package:WeServeU/model/product_model.dart';
import 'package:WeServeU/screen/offer_screen.dart';
import 'package:WeServeU/screen/standard_products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/product_provider.dart';
import '../providers/user_provider.dart';
import '../widget/MyProductListUnit.dart';
import '../widget/widgets.dart';
import 'add_product_screen.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({Key? key}) : super(key: key);
  static const routeName = '/my-product-screen';
  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var local=AppLocalizations.of(context);
    UserProvider userProvider=Provider.of<UserProvider>(context,listen: false);
    // Provider.of<ProductProvider>(context).getMyData();
    return Scaffold(
      body: Consumer<ProductProvider>(
        builder: (ctx, provider, c) {
          return provider.loading
              ? const ListLoadingShimmer()
              :  SingleChildScrollView(
                child: Column(
            children: [
                SizedBox(height: 16,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffb3d6ff),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(local.isShopOpen),
                        subtitle: Text(
                            local.ifyouswitchonthisyourshopwillbevisibletocustomers),
                        trailing: Switch(
                            value: userProvider.userModel?.shopStatus == 'open',
                            onChanged: (v) {
                              setState(() {
                                if(v){
                                  userProvider.userModel?.shopStatus='open';
                                  userProvider.updateShopStatus('open');
                                }else{
                                  userProvider.userModel?.shopStatus='closed';
                                  userProvider.updateShopStatus('closed');
                                }
                              });
                            }),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> StandardProducts()));
                          // addAllProducts(userProvider.userModel!.uid!);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(child: Text(local.addAllStandardProducts,textAlign: TextAlign.center,)),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Provider.of<ProductProvider>(context,listen: false).create();
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddProductScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(child: Text(local.addProducts)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child:Consumer<UserProvider>(builder: (BuildContext context, value, Widget? child) {
                        return GestureDetector(
                          onTap: (){
                            charge(
                                label: "${local.update} ${local.deliveryCharge}",
                                onClick: (text) {
                                  if (text != null && text.isNotEmpty) {
                                    value.updateCharge(double.parse(text));
                                  }
                                });
                          },
                          child: Container(
                              margin: EdgeInsets.all(8),
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(child: Text('${local.deliveryCharge} : ${value.userModel!.charge}'))),
                        );
                      },),
                    ),

                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> OfferScreen(uid: FirebaseAuth.instance.currentUser!.uid)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(child: Text('${local.offer}')),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if(provider.myList.isNotEmpty)Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                      itemBuilder: (ctx, index) {
                        return MyProductListUnit(
                            productModel: provider.myList[index]);
                      },
                      separatorBuilder: (ctx, index) {
                        return const SizedBox();
                      },
                      itemCount: provider.myList.length,shrinkWrap: true,physics: NeverScrollableScrollPhysics(),),
                ),
                if(provider.myList.isEmpty)SizedBox(height: 200,child: Center(child: Text(local.noProducts),)),
            ],
          ),
              );
        },
      ),
    );
  }
  charge({required String label, required Function(String) onClick}) async {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(label),
          content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                    labelText: label, border: const OutlineInputBorder()),
              )),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child:  Text(AppLocalizations.of(context).cancel)),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onClick(controller.text);
                },
                child: Text(AppLocalizations.of(context).update))
          ],
        );
      },
    );
  }

  void addAllProducts(String uid) async {
    await FirebaseDatabase.instance.ref('standardProducts').once().then((value) async {
      for(DataSnapshot snap in value.snapshot.children){
        ProductModel model=ProductModel.fromMap(snap.value as Map);

        await FirebaseDatabase.instance.ref('products').child(currency).child(model.key!).set(model.toMap());
      }
    });
  }
}

