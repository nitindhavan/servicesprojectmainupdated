import 'dart:convert';
import 'package:WeServeU/global.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:WeServeU/screen/shop_list_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../data/constants.dart';
import '../model/ImageModel.dart';
import '../model/address_model.dart';
import '../model/product_model.dart';
import '../model/user_model.dart';
import '../providers/address_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import '../widget/widgets.dart';
import 'carts.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  State<ShopScreen> createState() => _ShopScreenState(uid);

}

class _ShopScreenState extends State<ShopScreen> {
  String uid;
  bool paymentStarted = false;
  var scrollController=ScrollController();
  _ShopScreenState(this.uid);
  var searchController = TextEditingController();
  bool searchMode=false;

  String currentCategory="";
  @override
  Widget build(BuildContext context) {
    getDelivery(uid);
    var local = AppLocalizations.of(context);
    searchController.addListener(() {
      setState(() {
        searchController.text;
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    });
    return paymentStarted
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CircularProgressIndicator(),
              ),
              MyTitle(text: local.pleasedontcloseapp)
            ],
          )
        : WillPopScope(
          onWillPop: () async {
            if(searchMode){
              setState(() {
                searchMode=false;
              });
              return false;
            }else{
              return true;
            }
          },
          child: Scaffold(
              appBar: AppBar(
                title: Text(local.shop),
                backgroundColor: Color(0xff5e7af3),
              ),
              body: Consumer<CartProvider>(builder: (ctx, provider, c) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            Container(
                              child: FutureBuilder(
                                builder: (context,
                                    AsyncSnapshot<DatabaseEvent> snapshot) {
                                  if (snapshot.hasData) {
                                    UserModel userModel = UserModel.formMap(
                                        snapshot.data?.snapshot.value! as Map);
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if(!searchMode)ShopUnit(usermodel: userModel),
                                        if(!searchMode)Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xffd4e8ff),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            padding: EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: FutureBuilder(
                                                    builder: (context,
                                                        AsyncSnapshot<String>
                                                            snapshot) {
                                                      if (!snapshot.hasData)
                                                        return SizedBox();
                                                      return Text(
                                                        '${local.shopAddress} :- ${snapshot.data}',
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      );
                                                    },
                                                    future: getAdress(userModel),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${local.phoneNumber} :- ${userModel.mobile}',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 16,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    launchUrl(Uri.parse(
                                                        "tel://${userModel.mobile}"));
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color: Colors.indigo,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.call,
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(
                                                            width: 16,
                                                          ),
                                                          Text(
                                                            local.callThisShop,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    Colors.white),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if(!searchMode)SizedBox(
                                          height: 16,
                                        ),
                                        if(!searchMode)Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.only(left: 16),
                                            child: Text(
                                              local.shopImages,
                                              style: TextStyle(fontSize: 20),
                                              textAlign: TextAlign.start,
                                            )),
                                        if(!searchMode)Container(
                                          height: 200,
                                          child: FutureBuilder(
                                            builder: (context,
                                                AsyncSnapshot<DatabaseEvent>
                                                    snapshot) {
                                              if (snapshot.hasData) {
                                                List<ImageModel> imageModels = [];
                                                for (DataSnapshot snap
                                                    in (snapshot.data?.snapshot
                                                        .children)!) {
                                                  ImageModel imageModel =
                                                      ImageModel.fromMap(
                                                          snap.value as Map);
                                                  imageModels.add(imageModel);
                                                }
                                                if (imageModels.isEmpty) {
                                                  return Center(
                                                    child: Text(local
                                                        .shopHasnoImagetodisplay),
                                                  );
                                                }
                                                return ListView.builder(
                                                  itemBuilder: (context, index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        height: 200,
                                                        width: 200,
                                                        decoration: BoxDecoration(
                                                          color:
                                                              Color(0xffd4e8ff),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16.0),
                                                          child: Image.network(
                                                              imageModels[index]
                                                                  .imageUrl!),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  itemCount: imageModels.length,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                );
                                              } else {
                                                return SizedBox();
                                              }
                                            },
                                            future: FirebaseDatabase.instance
                                                .ref()
                                                .child('images')
                                                .orderByChild('shopUid')
                                                .equalTo(uid)
                                                .once(),
                                          ),
                                        ),
                                        if(!searchMode)SizedBox(
                                          height: 20,
                                        ),
                                        if(!searchMode)Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.only(left: 16),
                                            child: Text(
                                              local.offersOnlyforyou,
                                              style: TextStyle(fontSize: 20),
                                              textAlign: TextAlign.start,
                                            )),
                                        if(!searchMode)SizedBox(
                                          height: 16,
                                        ),
                                        if(!searchMode)FutureBuilder(
                                          builder: (BuildContext context,
                                              AsyncSnapshot<DatabaseEvent> snapshot) {
                                            if (snapshot.hasData) {
                                              List<ProductModel> models = [];
                                              for (DataSnapshot snap
                                                  in snapshot.data!.snapshot.children) {
                                                ProductModel model =
                                                    ProductModel.fromMap(snap.value as Map);
                                                if ((model.price ?? 0) > (model.offer ?? 0)) {
                                                  models.add(model);
                                                }
                                              }
                                              models.sort((a, b) => (a.offer! / a.price!)
                                                  .compareTo(b.offer! / b.price!));

                                              models.sort((a, b) => (a.type??"").compareTo(b.type??""));
                                              if (models.isNotEmpty) {
                                                return CarouselSlider(
                                                  options: CarouselOptions(
                                                      height: 500.0,
                                                      autoPlay: true,
                                                      autoPlayInterval: Duration(seconds: 2),
                                                      viewportFraction: 1.0),
                                                  items: models.map((i) {
                                                    return Builder(
                                                      builder: (BuildContext context) {
                                                        return ProductListUnit(
                                                            productModel: i);
                                                      },
                                                    );
                                                  }).toList(),
                                                );
                                              } else {
                                                return Container(
                                                  height: 200,
                                                  child: Center(
                                                    child: Text(local.noOffersForNow),
                                                  ),
                                                );
                                              }
                                            } else {
                                              return Text(local.noOffersForNow);
                                            }
                                          },
                                          future: FirebaseDatabase.instance
                                              .ref()
                                              .child('products')
                                              .child(currency)
                                              .orderByChild('sellerUID')
                                              .equalTo(uid)
                                              .once(),
                                        ),
                                        if(!searchMode)SizedBox(
                                          height: 24,
                                        ),
                                        GestureDetector(
                                          onTap: (){setState(() {
                                            searchMode=true;
                                          });},
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffd4e8ff),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.search),
                                                          SizedBox(
                                                            width: 8,
                                                          ),
                                                          Expanded(
                                                            child: Center(
                                                              child: TextField(
                                                                onTap: (){
                                                                  setState(() {
                                                                    searchMode=true;
                                                                  });
                                                                },
                                                                controller: searchController,
                                                                decoration: InputDecoration(
                                                                  hintText: local.search,
                                                                  border: InputBorder.none,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        FutureBuilder(
                                          builder: (context,
                                              AsyncSnapshot<DatabaseEvent> snapshot) {
                                            if (snapshot.hasData) {
                                              List<ProductModel> modelList = [];
                                              List<String> types=[];
                                              for (DataSnapshot snap
                                                  in (snapshot.data?.snapshot.children)!) {
                                                ProductModel model =
                                                    ProductModel.fromMap(snap.value! as Map);
                                                if(model.live ?? false ) {
                                                  if((model.price!) <= (model.offer ?? 0))
                                                  modelList.add(model);
                                                  if(!types.contains(model.type)) types.add(model.type??"");
                                                }
                                                // if(types.isNotEmpty) currentCategory=types[0];
                                              }
                                              return Column(
                                                children: [
                                                  Container(width: double.infinity,padding: EdgeInsets.all(8),child: Text(local.productType)),
                                                  SizedBox(
                                                    height: 70,
                                                    child: ListView.builder(itemBuilder: (BuildContext context, int index) {
                                                      return GestureDetector(
                                                        onTap: (){
                                                          setState(() {
                                                            currentCategory=types[index];
                                                          });
                                                        },
                                                        child: Container(margin: EdgeInsets.all(8),height: 60,decoration: BoxDecoration(color: currentCategory!= types[index]?Colors.blue.shade100 : Colors.green.shade200,borderRadius: BorderRadius.circular(5)),child: Center(child: Padding(
                                                          padding: const EdgeInsets.all(16.0),
                                                          child: Text("${local.productType} : ${types[index]}"),
                                                        ))),
                                                      );
                                                    },itemCount: types.length,scrollDirection: Axis.horizontal,),
                                                  ),
                                                  SizedBox(
                                                    height: 16,
                                                  ),
                                                  Container(
                                                      width: double.infinity,
                                                      padding: EdgeInsets.only(left: 16),
                                                      child: Text(
                                                        local.products,
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(fontSize: 20),
                                                      )),
                                                  SizedBox(
                                                    height: 24,
                                                  ),
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    key: Key(searchController.text+currentCategory),
                                                    itemBuilder: (context, index) {
                                                      bool atleastOne=false;
                                                      for(ProductModel model in modelList){
                                                        if((model.name ?? '').toLowerCase().contains(searchController.text.toLowerCase()) && currentCategory==model.type) atleastOne=true;
                                                      }
                                                      if(!atleastOne && index==0) return Container(height: 200, child: Center(child: Text('${local.noProducts}'),),);
                                                      if ((modelList[index]
                                                          .name ?? '')
                                                          .toLowerCase()
                                                          .contains(searchController.text
                                                              .toLowerCase()) && currentCategory==modelList[index].type)
                                                        return ProductListUnit(
                                                            productModel: modelList[index]);
                                                      return SizedBox();
                                                    },
                                                    itemCount: modelList.length,
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return Center(
                                                child: Text(local.thisShopHasnoproducts),
                                              );
                                            }
                                          },
                                          future: FirebaseDatabase.instance
                                              .ref()
                                              .child('products')
                                              .child(currency)
                                              .orderByChild('sellerUID')
                                              .equalTo(uid)
                                              .once(),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                },
                                future: FirebaseDatabase.instance
                                    .ref()
                                    .child('users')
                                    .child(uid)
                                    .once(),
                              ),

                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffb3d6ff),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 50,
                                child: Center(
                                    child: Text('$currency ${provider.total()}')),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CartsScreen()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 50,
                                  child: Center(
                                      child: Text('${local.placeaOrder}',style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.bold),)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }),
            ),
        );
  }

  UsePaypal payPalPayment(BuildContext ctx, AddressModel addressModel) {
    final carts = Provider.of<CartProvider>(ctx, listen: false);
    return UsePaypal(
        sandboxMode: true,
        onSuccess: (v) {
          ScaffoldMessenger.of(ctx)
              .showSnackBar(SnackBar(content: Text('Success: $v')));
        },
        onError: (v) {
          ScaffoldMessenger.of(ctx)
              .showSnackBar(SnackBar(content: Text('Error: $v')));
        },
        onCancel: (v) {
          var string = (v?['code']).toString();
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Text(
                  'Cancelled: ${string.replaceAll('_', " ").toLowerCase().replaceRange(0, 1, string.substring(0, 1).toUpperCase())}')));
        },
        returnURL: '/',
        cancelURL: '/',

        ///below are ther details of products in cart
        ///shipping detail
        transactions: [
          {
            "amount": {
              "total": carts.total(),
              "currency": currency,
              "details": {
                "subtotal": (toDouble(carts.total()) - CartProvider.deliveryCharge)
                    .toStringAsFixed(2),
                "shipping": CartProvider.deliveryCharge,
                "shipping_discount": 0
              }
            },
            "description": description,
            // "payment_options": {
            //   "allowed_payment_method":
            //       "INSTANT_FUNDING_SOURCE"
            // },
            "item_list": {
              "items":
                  // {
                  //   "name": "A demo product",
                  //   "quantity": 1,
                  //   "price": '10.12',
                  //   "currency": currency
                  // }
                  carts.cartsList
                      .map((e) => {
                            'name': e.name,
                            'quantity': e.quantity,
                            'price': e.price,
                            'currency': currency,
                          })
                      .toList(),

              // shipping address is not required though
              "shipping_address": {
                "recipient_name": addressModel.recipientName,
                "line1": addressModel.line1,
                "line2": addressModel.line2,
                "city": addressModel.city,
                "country_code": addressModel.countryCode,
                "postal_code": addressModel.postalCode,
                "phone": addressModel.phone,
                "state": addressModel.state
              },
            }
          }
        ],
        note: note,
        clientId: clientId,
        secretKey: secretKeyPayPal);
  }

  double toDouble(String deliveryCharge) {
    return double.tryParse(deliveryCharge) ?? 0.0;
  }

  late Razorpay _razorpay;

  @override
  void initState() {
    _razorpay = Razorpay();
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse v) {
      if (paymentStarted) {
        setState(() {
          paymentStarted = false;
        });
      }

      final provider = Provider.of<CartProvider>(context, listen: false);
      final addressModel =
          Provider.of<AddressProvider>(context, listen: false).addressModel;
      Provider.of<OrdersProvider>(context, listen: false).order(
          provider.cartsList,
          addressModel: addressModel!,
          orderId: v.orderId,
          paymentId: v.paymentId,
          signature: v.signature,
          note: '',
          deliveryCharge: CartProvider.deliveryCharge,
          paymentMethod: 'RazorPay',
          amount: double.parse(provider.total()) * commission / 100,
          sellerUID: provider.cartsList[0].sellerUID!,
          paymentStatus: 'Paid');

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Payment is successful')));
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse v) {
      final e = jsonDecode(v.message!);
      e as Map<dynamic, dynamic>;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${e['error']?['description']}')));

      if (paymentStarted) {
        setState(() {
          paymentStarted = false;
        });
      }
    });
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse v) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${v.walletName}')));
      if (paymentStarted) {
        setState(() {
          paymentStarted = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<String> getAdress(UserModel userModel) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        userModel.latitude ?? 0, userModel.longitude ?? 0);
    return '${placemarks.first.street}, ${placemarks.first.subLocality}, ${placemarks.first.locality as String} ';
  }
  Future<void> getDelivery(String sellerUid) async{
    await FirebaseDatabase.instance.ref("users").child(sellerUid).child('charge').once().then((value){
      try {
        CartProvider.deliveryCharge = value.snapshot.value as double;
      }catch(e){
        CartProvider.deliveryCharge=int.parse(value.snapshot.value.toString()).toDouble();
      }
    });
  }
}
