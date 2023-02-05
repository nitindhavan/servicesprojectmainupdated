import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../data/constants.dart';
import '../model/product_model.dart';
import '../providers/product_provider.dart';
import '../widget/widgets.dart';
import 'add_product_screen.dart';

class StandardProducts extends StatefulWidget {
  const StandardProducts({Key? key}) : super(key: key);
  static const routeName = '/my-product-screen';
  @override
  State<StandardProducts> createState() => _StandardProductsState();
}

class _StandardProductsState extends State<StandardProducts> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var local=AppLocalizations.of(context);
    // Provider.of<ProductProvider>(context).getMyData();
    return Scaffold(
      body: FutureBuilder(builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
        List<ProductModel> myList=[];
        for(DataSnapshot snap in snapshot.data!.snapshot.children) {
          ProductModel model = ProductModel.fromMap(snap.value as Map);
          myList.add(model);
        }
        if(myList.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
                itemBuilder: (ctx, index) {
                  return MyStandardProductListUnit(
                      productModel: myList[index]);
                },
                separatorBuilder: (ctx, index) {
                  return const SizedBox();
                },
                itemCount: myList.length),
          );
        }else {
          return Center(child: Text(local.noProducts),);
        }
      },future: FirebaseDatabase.instance.ref('standardProducts').once(),),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(local.standardProducts),
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
}
class MyStandardProductListUnit extends StatelessWidget {
  final ProductModel productModel;

  const MyStandardProductListUnit({Key? key, required this.productModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffb3d6ff),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0,top: 8,right: 4),
                      child: Container(
                          width: 144,
                          height: 144,
                          decoration: BoxDecoration(
                            color: Color(0xffd4e8ff),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: LoadImage(path: productModel.photoUrl![0] as String),
                          )),
                    ),
                  ],
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0,top: 8,right: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xffd4e8ff),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyTitle(text: '${productModel.name}'),
                            MySubTitle(
                                text: '${AppLocalizations.of(context).quantity}: ${productModel.quantity ?? 0} ${AppLocalizations.of(context).liters}'),
                            MySubTitle(
                                text: '${AppLocalizations.of(context).price}: $currency ${productModel.price ?? 0.0}'),
                            MySubTitle(
                                text:
                                '${AppLocalizations.of(context).deliveryCharge}: $currency ${productModel.deliveryCharge ?? 0.0}'),
                            TextButton(
                                onPressed: () async {
                                  String? newKey=await FirebaseDatabase.instance.ref('products').child(currency).push().key;
                                  productModel.key=newKey;
                                  productModel.sellerUID=FirebaseAuth.instance.currentUser!.uid;
                                  Provider.of<ProductProvider>(context, listen: false)
                                      .productModel = productModel;
                                  Navigator.pushNamed(context, AddProductScreen.routeName);
                                },
                                child: Icon(Icons.add)),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
           SizedBox(height: 8,),
          ],
        ),
      ),
    );
  }
}


