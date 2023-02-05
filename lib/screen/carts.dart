import 'package:WeServeU/dashboards/client_dashboard.dart';
import 'package:WeServeU/data/constants.dart';
import 'package:WeServeU/global.dart';
import 'package:WeServeU/model/address_model.dart';
import 'package:WeServeU/providers/address_provider.dart';
import 'package:WeServeU/providers/orders_provider.dart';
import 'package:WeServeU/providers/wallet_provider.dart';
import 'package:WeServeU/screen/adresses_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/cart_provider.dart';
import '../widget/widgets.dart';
import 'add_address_screen.dart';


class CartsScreen extends StatefulWidget {
  const CartsScreen({Key? key}) : super(key: key);
  static const routeName = '/carts-screen';

  @override
  State<CartsScreen> createState() => _CartsScreenState();
}

class _CartsScreenState extends State<CartsScreen> {
  bool paymentStarted = false;
  var noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var local = AppLocalizations.of(context);
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
        : Scaffold(
      appBar: AppBar(
        title: Text(local.cart),
        backgroundColor: Color(
            0xff5e7af3),
      ),
      body: Consumer<CartProvider>(builder: (ctx, provider, c) {
        return Column(
          children: [
            Expanded(
                child: provider.loading
                    ? const ListLoadingShimmer()
                    : provider.cartsList.isEmpty
                    ? const Empty()
                    : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                      itemBuilder: (ctx, index) {
                        if (index == provider.cartsList.length - 1) {
                          return Column(
                            children: [
                              CartListUnit(
                                  cartModel:
                                  provider.cartsList[index]),

                              SizedBox(height: 16,),
                              Container(padding: EdgeInsets.only(left: 8),
                                  width: double.infinity,
                                  child: Text(local.note, style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,)),
                              Container(margin: EdgeInsets.only(left: 8),
                                child: Text(local.addANote),
                                width: double.infinity,),
                              SizedBox(height: 8,),
                              Container(
                                margin: EdgeInsets.all(4),
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(16)
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: local.addYourNote
                                  ),
                                  controller: noteController,
                                  minLines: 1,
                                  maxLines: 10,
                                ),
                              ),
                              SizedBox(height: 8,),
                              Container(padding: EdgeInsets.only(left: 8),
                                  width: double.infinity,
                                  child: Text(local.paymentSummary,
                                    style: TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,)),
                              SizedBox(height: 16,),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffb3d6ff),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(local.subTotal, style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),),
                                          Text('${provider.subTotal} $currency',
                                            style: TextStyle(fontSize: 16),),
                                        ],
                                      ),
                                      SizedBox(height: 16,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(local.deliveryCharge,
                                            style: TextStyle(fontSize: 16,
                                                fontWeight: FontWeight.bold),),
                                          Text('${CartProvider
                                              .deliveryCharge} $currency',
                                            style: TextStyle(fontSize: 16,),),
                                        ],
                                      ),
                                      SizedBox(height: 16,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(local.appCharges,
                                            style: TextStyle(fontSize: 16,
                                                fontWeight: FontWeight.bold),),
                                          Text('${commission *
                                              (CartProvider.deliveryCharge +
                                                  double.parse(
                                                      provider.subTotal)) /
                                              100} $currency',
                                            style: TextStyle(fontSize: 16,),),
                                        ],
                                      ),
                                      SizedBox(height: 16,),
                                      Text(
                                          '---------------------------------------------------'),
                                      SizedBox(height: 16,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(local.total, style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),),
                                          Text('${provider.total()} $currency',
                                            style: TextStyle(fontSize: 16,),),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return CartListUnit(
                              cartModel:
                              provider.cartsList[index]);
                        }
                      },
                      separatorBuilder: (ctx, index) {
                        return const Divider();
                      },
                      itemCount: provider.cartsList.length),
                )),
            if(provider.cartsList.isNotEmpty)Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(color: Color(0xff5e7af3),
                    borderRadius: BorderRadius.circular(10)),
                width: double.infinity,
                child: TextButton(
                    onPressed: () async {
                      final addresses = Provider.of<AddressProvider>(
                          context,
                          listen: false);
                      addresses.addressModel = null;
                      await showModalBottomSheet(
                          context: context,
                          builder: (ctx) {
                            return Consumer<AddressProvider>(
                                builder: (context, provider, _) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        MyTitle(
                                          text: local
                                              .pleaseSelectAddresstocontinue,),
                                        if(provider.addressList
                                            .isEmpty)Expanded(child: Center(
                                            child: Text(local.noAdress)),),
                                        Expanded(
                                            child: ListView(
                                              children: provider.addressList
                                                  .map((e) =>
                                                  AddressUnit(
                                                    addressModel: e,
                                                    selection: true,
                                                  ))
                                                  .toList(),
                                            )),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            FloatingActionButton.extended(
                                              backgroundColor: Color(
                                                  0xff5e7af3),
                                              onPressed: () async {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (ctx) {
                                                          return const AddAddressScreen();
                                                        }));
                                              },
                                              label:
                                              Text(local.newAddress),
                                              icon: const Icon(
                                                  Icons.location_city),
                                            ),
                                            FloatingActionButton.extended(
                                              backgroundColor: Color(
                                                  0xff5e7af3),
                                              onPressed: () async {
                                                if (addresses.addressModel !=
                                                    null) {
                                                  Navigator.pop(context);
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                      local
                                                          .pleaseSelectAddresstocontinue);
                                                }
                                              },
                                              label: Text(local.confirm),
                                              icon: const Icon(
                                                  Icons.navigate_next),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                });
                          });
                      if (addresses.addressModel == null) {
                        return;
                      }
                      AddressModel addressModel = addresses.addressModel!;
                      // addresses.addressModel = null;

                      await showModalBottomSheet(
                          context: context,
                          builder: (ctx) {
                            return Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView(
                                  children: [
                                    MyTitle(
                                        text:
                                        local
                                            .pleaseSelectPaymentmethodtocontinue),
                                    // MyCustomCard(
                                    //   padding: 2.0,
                                    //   elevation: 0.0,
                                    //   margin: 2.0,
                                    //   radius: 2.0,
                                    //   child: ListTile(
                                    //     leading: SizedBox(
                                    //       width: 48,
                                    //       child: CachedNetworkImage(
                                    //         imageUrl:
                                    //             'https://www.paypalobjects.com/digitalassets/c/website/marketing/na/us/logo-center/Badge_2.png',
                                    //         placeholder: (ctx, er) {
                                    //           return const MyShimmerSkeleton();
                                    //         },
                                    //       ),
                                    //     ),
                                    //     title: const Text(
                                    //       'PayPal',
                                    //       style: TextStyle(
                                    //           color: Colors.blue,
                                    //           fontWeight:
                                    //               FontWeight.bold),
                                    //     ),
                                    //     onTap: () {
                                    //       Navigator.of(context).pop();
                                    //       Navigator.of(context).push(
                                    //           MaterialPageRoute(
                                    //               builder: (ctx) {
                                    //         return payPalPayment(
                                    //             ctx, addressModel);
                                    //       }));
                                    //     },
                                    //   ),
                                    // ),
                                    MyCustomCard(
                                      padding: 2.0,
                                      elevation: 0.0,
                                      margin: 2.0,
                                      radius: 2.0,
                                      child: ListTile(
                                        leading: SizedBox(
                                          width: 48,
                                          child: Image.asset(
                                              'assets/cod.jpg'),
                                        ),
                                        title: Text(
                                          local.cashOnDelivery,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                        onTap: () async {
                                          Provider.of<OrdersProvider>(
                                              context,
                                              listen: false)
                                              .order(provider.cartsList,
                                              addressModel:
                                              addressModel,
                                              paymentMethod:
                                              'COD',
                                              note: noteController.text,
                                              deliveryCharge: CartProvider
                                                  .deliveryCharge,
                                              paymentStatus: 'Pending',
                                              amount: double.parse(
                                                  provider.total()) *
                                                  commission / 100,
                                              sellerUID: provider.cartsList[0]
                                                  .sellerUID!);
                                          ScaffoldMessenger.of(
                                              context)
                                              .showSnackBar(SnackBar(
                                              content: Text(
                                                  local.orderReceivedThanks)));
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ClientDashBoard()));
                                        },
                                      ),
                                    ),
                                    MyCustomCard(
                                      padding: 2.0,
                                      elevation: 0.0,
                                      margin: 2.0,
                                      radius: 2.0,
                                      child: ListTile(
                                        leading: const SizedBox(
                                          width: 48,
                                          child: Icon(Icons.credit_card),
                                        ),
                                        title: const Text(
                                          'PayPal/Credit/Debit Card',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            paymentStarted = true;
                                          });
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  UsePaypal(
                                                      sandboxMode: true,
                                                      clientId:
                                                      clientId,
                                                      secretKey:
                                                      secretKeyPayPal,
                                                      returnURL: "https://samplesite.com/return",
                                                      cancelURL: "https://samplesite.com/cancel",
                                                      transactions: [
                                                        {
                                                          "amount": {
                                                            "total": '${provider
                                                                .total()}',
                                                            "currency": "JOD",
                                                            "details": {
                                                              "subtotal": '${provider
                                                                  .total()}',
                                                              "shipping": '0',
                                                              "shipping_discount": 0
                                                            }
                                                          },
                                                          "description":
                                                          "The payment transaction description.",
                                                          "item_list": {
                                                            "items": [
                                                              {
                                                                "name": "Total Bill",
                                                                "quantity": 1,
                                                                "price": '${provider
                                                                    .total()}',
                                                                "currency": "JOD"
                                                              }
                                                            ],
                                                          }
                                                        }
                                                      ],
                                                      note: "Contact us for any questions on your order.",
                                                      onSuccess: (
                                                          Map params) async {
                                                        print(
                                                            "onSuccess: $params");
                                                        if (paymentStarted) {
                                                          setState(() {
                                                            paymentStarted =
                                                            false;
                                                          });
                                                        }
                                                        ScaffoldMessenger.of(
                                                            context)
                                                            .showSnackBar(
                                                            SnackBar(
                                                                content: Text(
                                                                    AppLocalizations
                                                                        .of(
                                                                        context)
                                                                        .orderReceivedThanks)));
                                                        final provider = Provider
                                                            .of<CartProvider>(
                                                            context,
                                                            listen: false);
                                                        final addressModel =
                                                            Provider
                                                                .of<
                                                                AddressProvider>(
                                                                context,
                                                                listen: false)
                                                                .addressModel;
                                                        Provider.of<
                                                            OrdersProvider>(
                                                            context,
                                                            listen: false)
                                                            .order(provider
                                                            .cartsList,
                                                            addressModel: addressModel!,
                                                            note: noteController
                                                                .text,
                                                            deliveryCharge: CartProvider
                                                                .deliveryCharge,
                                                            paymentMethod: 'RazorPay',
                                                            paymentStatus: 'Paid',
                                                            sellerUID: provider
                                                                .cartsList[0]
                                                                .sellerUID!,
                                                            amount: double
                                                                .parse(provider
                                                                .total()) *
                                                                commission / 100
                                                        );

                                                        ScaffoldMessenger.of(
                                                            context)
                                                            .showSnackBar(
                                                            SnackBar(
                                                                content: Text(
                                                                    AppLocalizations
                                                                        .of(
                                                                        context)
                                                                        .paymentissuccessful)));
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder: (
                                                                    context) =>
                                                                    ClientDashBoard()));
                                                      },
                                                      onError: (error) {
                                                        print(
                                                            "onError: $error");
                                                      },
                                                      onCancel: (params) {
                                                        print(
                                                            'cancelled: $params');
                                                      }),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    MyCustomCard(
                                      padding: 2.0,
                                      elevation: 0.0,
                                      margin: 2.0,
                                      radius: 2.0,
                                      child: ListTile(
                                        leading: const SizedBox(
                                          width: 48,
                                          child: Icon(Icons.credit_card),
                                        ),
                                        title: Text(
                                          local.wallet,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                        onTap: () async {
                                          var wallet = Provider.of<
                                              WalletProvider>(
                                              context, listen: false);
                                          if (double.parse(provider.total()) <=
                                              wallet.walletModel.amount) {
                                            wallet.credit(-1 *
                                                double.parse(provider.total()));
                                           Provider.of<OrdersProvider>(
                                                context,
                                                listen: false)
                                                .order(provider.cartsList,
                                                deliveryCharge: CartProvider
                                                    .deliveryCharge,
                                                addressModel:
                                                addressModel,
                                                note: noteController.text,
                                                paymentMethod:
                                                'WALLET',
                                                paymentStatus: 'Pending',
                                                amount: double.parse(
                                                    provider.total()) *
                                                    commission / 100,
                                                sellerUID: provider.cartsList[0]
                                                    .sellerUID!);
                                            ScaffoldMessenger.of(
                                                context)
                                                .showSnackBar(SnackBar(
                                                content: Text(
                                                    local.orderReceivedThanks)));
                                          } else {
                                            ScaffoldMessenger.of(
                                                context)
                                                .showSnackBar(SnackBar(
                                                content: Text(
                                                    local.notEnoughBalance)));
                                          }

                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ClientDashBoard()));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Text(
                      local.confirmOrder, style: TextStyle(color: Colors
                        .white),)),
              ),
            )
          ],
        );
      }),
    );
  }

  UsePaypal payPalPayment(BuildContext ctx, AddressModel addressModel) {
    var local = AppLocalizations.of(ctx);
    final carts = Provider.of<CartProvider>(ctx, listen: false);
    return UsePaypal(
        sandboxMode: true,
        onSuccess: (v) {
          ScaffoldMessenger.of(ctx)
              .showSnackBar(SnackBar(content: Text('${local.success}: $v')));
        },
        onError: (v) {
          ScaffoldMessenger.of(ctx)
              .showSnackBar(SnackBar(content: Text('${local.error}: $v')));
        },
        onCancel: (v) {
          var string = (v?['code']).toString();
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
              content: Text(
                  '${local.cancelled}: ${string.replaceAll('_', " ")
                      .toLowerCase()
                      .replaceRange(
                      0, 1, string.substring(0, 1).toUpperCase())}')));
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
                "subtotal":
                (toDouble(carts.total()) - CartProvider.deliveryCharge)
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
                  .map((e) =>
              {
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
    double charge = 0.0;
    try {
      charge = double.parse(deliveryCharge);
    } catch (e) {
      charge = int.parse(deliveryCharge).toDouble();
    }
    return charge;
  }


  @override
  void initState() {
    super.initState();
  }
}

///Cart
///try{
//                                             final response=await http.post(Uri.parse('https://us-central1-stripe-checkout-flutter.cloudfunctions.net/stripePaymentIntentRequest',),
//                                                 body: {
//                                                   'mobile':FirebaseAuth.instance.currentUser!.phoneNumber,
//                                                   'currency':currency,
//                                                   'amount':'100'
//                                                 }
//                                             );
//
//                                             final body=jsonDecode(response.body);
//                                             print(body);
//
//                                             // Provider.of<OrdersProvider>(context,listen: false).order(provider.cartsList,addressModel: addressModel);
//                                             final x=await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
//                                               paymentIntentClientSecret: body['paymentIntent'],
//                                               merchantDisplayName: 'WeServeU',
//                                               customerId: body['customer'],
//                                               customerEphemeralKeySecret: body['ephemeralKey'],
//                                               testEnv: true,
//                                               merchantCountryCode: currency.substring(0,2),
//                                               style: ThemeMode.light,
//
//                                             ));
//
//                                              await Stripe.instance.presentPaymentSheet();
//
//
//                                           }catch(e){
//
//                                             print(e);
//                                           }
