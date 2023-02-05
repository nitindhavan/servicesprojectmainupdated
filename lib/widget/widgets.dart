import 'package:WeServeU/model/cart_model.dart';
import 'package:WeServeU/model/map_model.dart';
import 'package:WeServeU/model/user_model.dart';
import 'package:WeServeU/providers/cart_provider.dart';
import 'package:WeServeU/providers/orders_provider.dart';
import 'package:WeServeU/providers/user_provider.dart';
import 'package:WeServeU/screen/order_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../data/constants.dart';
import '../model/order_model.dart';
import '../model/product_model.dart';
import '../providers/product_provider.dart';
import '../providers/running_status_provider.dart';
import '../screen/add_product_screen.dart';
import '../screen/map_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../screen/order_detail_screen_client.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../screen/shop_screen.dart';

class InfoWidget extends StatelessWidget {
  final String info;
  final Color color;

  const InfoWidget(
    this.info, {
    Key? key,
    this.color = Colors.redAccent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0), color: color),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            info,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

/// OTP Box to enter otp

class OtpUnit extends StatelessWidget {
  const OtpUnit({
    Key? key,
    required this.focuses,
    required this.i,
    required this.constraint,
    required this.userOtp,
  }) : super(key: key);

  final List<FocusNode> focuses;
  final int i;
  final BoxConstraints constraint;
  final Map<int, TextEditingController> userOtp;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: constraint.maxWidth / 8,
      child: MyContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextFormField(
            focusNode: focuses[i],
            style: const TextStyle(fontSize: 20.0),
            textAlign: TextAlign.center,
            controller: userOtp[i],
            onChanged: (v) {
              if (v.length > 1) {
                v = v.substring(0, 1);
                userOtp[i]!.text = v;
              }
              if (v.length == 1) {
                userOtp[i]!.text = v;
                if (i < 5) {
                  FocusScope.of(context).requestFocus(focuses[i + 1]);
                } else {
                  FocusScope.of(context).unfocus();
                }
              }
            },
            validator: (v) {
              if (v == null || v.isEmpty) {
                return '';
              }
              return null;
            },
            onSaved: (v) {
              userOtp[i]!.text = v ?? '';
            },
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            smartDashesType: SmartDashesType.enabled,
            keyboardType: TextInputType.number,
            textInputAction:
                i == 5 ? TextInputAction.done : TextInputAction.next,
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
      ),
    );
  }
}

class MyCustomCard extends StatelessWidget {
  final Widget child;

  final double topLeft;
  final double margin;
  final double elevation;
  final double topRight;
  final double padding;
  final double bottomLeft;
  final Color color;
  final double bottomRight;
  final double? radius;

  const MyCustomCard(
      {Key? key,
      required this.child,
      this.topLeft = 8.0,
      this.topRight = 8.0,
      this.padding = 8.0,
      this.color = Colors.white,
      this.elevation = 4.0,
      this.bottomLeft = 8.0,
      this.margin = 4.0,
      this.bottomRight = 8.0,
      this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
            borderRadius: radius != null
                ? BorderRadius.circular(radius!)
                : BorderRadius.only(
                    topLeft: Radius.circular(topLeft),
                    topRight: Radius.circular(topRight),
                    bottomLeft: Radius.circular(bottomLeft),
                    bottomRight: Radius.circular(bottomRight),
                  )),
        margin: EdgeInsets.symmetric(vertical: margin),
        elevation: elevation,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}

/// Special container to customize card with border radius,
/// color, padding, border,  easily

class MyContainer extends StatelessWidget {
  final Widget child;
  final double radius;
  final Color color;
  final Color background;
  final double width;
  final double padding;
  final BorderStyle borderStyle;

  const MyContainer(
      {Key? key,
      required this.child,
      this.radius = 8.0,
      this.padding = 0.0,
      this.background = Colors.white,
      this.color = Colors.blueGrey,
      this.borderStyle = BorderStyle.solid,
      this.width = 0.50})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Container(
          decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              border:
                  Border.all(color: color, width: width, style: borderStyle)),
          child: child),
    );
  }
}

/// before receiving image file from firebase storage we can show Shimmer (Loading animation)

class LoadImage extends StatelessWidget {
  final String? path;

  const LoadImage({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Builder(builder: (context) {
        if (path == null) {
          return const MyShimmerSkeleton(
            width: double.infinity,
          );
        }
        return CachedNetworkImage(
          imageUrl: path!,
          fit: BoxFit.cover,
          placeholder: (c, s) {
            return const MyShimmer(
                child: MyShimmerSkeleton(width: double.infinity));
          },
        );
      }),
    );
  }
}

/// modal shimmer is shown at the time of loading
class ModelShimmer extends StatelessWidget {
  const ModelShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1),
      child: MyCustomCard(
        padding: 8.0,
        elevation: 1.0,
        radius: 12.0,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return MyShimmer(
              child: Stack(
                children: [
                  Row(
                    children: [
                      MyShimmerSkeleton(
                        width: constraints.maxWidth * 0.25,
                        height: constraints.maxWidth * 0.25,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyShimmerSkeleton(
                                    height: 2,
                                    width: constraints.maxWidth * 0.4,
                                  ),
                                  const MyShimmerSkeleton(
                                    height: 2,
                                    width: 24,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  MyShimmerSkeleton(
                                    height: 2,
                                    width: 100,
                                  ),
                                  MyShimmerSkeleton(
                                    height: 2,
                                    width: 24,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  MyShimmerSkeleton(
                                    height: 2,
                                    width: 100,
                                  ),
                                  MyShimmerSkeleton(
                                    height: 2,
                                    width: 24,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// expandable appbar is shown while loading
class SliverAppBarShimmer extends StatelessWidget {
  const SliverAppBarShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const SliverAppBar(
      iconTheme: IconThemeData(color: Colors.cyan),
      backgroundColor: Colors.white,
      expandedHeight: 256.0,
      title: MyShimmer(
          child: MyShimmerSkeleton(
        width: 100,
      )),
      pinned: true,
      elevation: 1,
      leading: MyShimmer(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: MyShimmerSkeleton(
            width: 8,
            height: 8,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: ClipRRect(
            child: MyShimmer(
                child: LoadImage(
          path: null,
        ))),
      ),
      actions: [
        MyShimmer(
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: MyShimmerSkeleton(
              width: 8,
              height: 8,
            ),
          ),
        ),
      ],
    );
  }
}

///Normal app bar
AppBar appBarShimmer() {
  return AppBar(
    iconTheme: const IconThemeData(color: Colors.cyan),
    backgroundColor: Colors.white,
    title: const MyShimmer(
        child: MyShimmerSkeleton(
      width: 100,
    )),
    elevation: 1,
    leading: MyShimmer(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: MyShimmerSkeleton(
          width: 8,
          height: 8,
        ),
      ),
    ),
    actions: [
      MyShimmer(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: MyShimmerSkeleton(
            width: 8,
            height: 8,
          ),
        ),
      ),
    ],
  );
}

class MyShimmerSkeleton extends StatelessWidget {
  final double? height;
  final double? width;
  final double padding;

  const MyShimmerSkeleton(
      {Key? key, this.height, this.width, this.padding = 8.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(padding / 2),
      child: MyContainer(
        color: Colors.transparent,
        background: Colors.black.withOpacity(0.04),
        radius: padding,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: SizedBox(
            height: height,
            width: width,
          ),
        ),
      ),
    );
  }
}

class ListLoadingShimmer extends StatelessWidget {
  const ListLoadingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, pos) {
          return MyShimmer(
            child: Row(
              children: [
                const SizedBox(
                  width: 144,
                  height: 144,
                  child: LoadImage(path: null),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    MyShimmerSkeleton(
                      width: 200,
                    ),
                    MyShimmerSkeleton(
                      width: 180,
                    ),
                    MyShimmerSkeleton(
                      width: 150,
                    ),
                  ],
                ))
              ],
            ),
          );
        });
  }
}

class MyShimmer extends StatelessWidget {
  final Widget child;

  const MyShimmer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Shimmer.fromColors(
        child: child, baseColor: baseColor, highlightColor: highlightColor);
  }
}

///label text widget for showing label
class MyTitle extends StatelessWidget {
  const MyTitle({
    Key? key,
    required this.text,
    this.padding = 8.0,
    this.alignment = Alignment.bottomLeft,
    this.color,
    this.style,
  }) : super(key: key);

  final String text;
  final double padding;
  final Alignment alignment;
  final Color? color;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.only(left: padding, top: padding, bottom: padding),
        child: Text(text,
            style: style ??
                Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(fontWeight: FontWeight.w500, color: color)),
      ),
    );
  }
}

///label text widget for showing label
class MySubTitle extends StatelessWidget {
  const MySubTitle({
    Key? key,
    required this.text,
    this.padding = 8.0,
    this.alignment = Alignment.bottomLeft,
    this.color,
    this.style,
  }) : super(key: key);

  final String text;
  final double padding;
  final Alignment alignment;
  final Color? color;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.only(
            left: padding, top: padding / 2, bottom: padding / 2),
        child: Text(text,
            style: style ??
                Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.bold, color: color, fontSize: 12)),
      ),
    );
  }
}

class ProductListUnit extends StatefulWidget {
  ProductListUnit({Key? key, required this.productModel}) : super(key: key);
  final ProductModel productModel;
  @override
  State<ProductListUnit> createState() => _ProductListUnitState(productModel);
}

class _ProductListUnitState extends State<ProductListUnit> {
  final ProductModel productModel;

  _ProductListUnitState(this.productModel);

  late num quantity = 0;
  String currentString = '';
  int current=0;
  WebViewController? controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('${AppLocalizations.of(context).productType} : ${productModel.type ?? "Type"}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xffd4e8ff),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productModel.photoUrl !=null ? SizedBox(
                            height: 250,
                            child: Row(
                              children: [
                                SingleChildScrollView(
                                    child:  Column(
                                      children: [
                                        productModel.photoUrl!.isNotEmpty ? GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              current=0;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 4.0,top: 8,right: 4),
                                            child: Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: Color(0xffd4e8ff),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: productModel.photoUrl !=null ? LoadImage(path: productModel.photoUrl![0] as String) : SizedBox(),
                                                )),
                                          ),
                                        ) : SizedBox(),
                                        if(productModel.photoUrl!.length > 1)  GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              current=1;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 4.0,top: 8,right: 4),
                                            child: Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: Color(0xffd4e8ff),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: productModel.photoUrl !=null ? LoadImage(path: productModel.photoUrl![1] as String) : SizedBox(),
                                                )),
                                          ),
                                        ),
                                        if(productModel.photoUrl!.length > 2) GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              current=2;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 4.0,top: 8,right: 4),
                                            child: Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: Color(0xffd4e8ff),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: productModel.photoUrl !=null ? LoadImage(path: productModel.photoUrl![2] as String) : SizedBox(),
                                                )),
                                          ),
                                        ),
                                        if(productModel.photoUrl!.length > 3) GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              current=3;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 4.0,top: 8,right: 4),
                                            child: Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: Color(0xffd4e8ff),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: productModel.photoUrl !=null ? LoadImage(path: productModel.photoUrl![3] as String) : SizedBox(),
                                                )),
                                          ),
                                        ),
                                        if(productModel.photoUrl!.length > 4)GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              current=4;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 4.0,top: 8,right: 4),
                                            child: Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: Color(0xffd4e8ff),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: productModel.photoUrl !=null ? LoadImage(path: productModel.photoUrl![4] as String) : SizedBox(),
                                                )),
                                          ),
                                        ),
                                        if(productModel.videoUrl!=null && productModel.videoUrl!.isNotEmpty)GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              current=5;
                                              if(controller!=null)controller!.loadUrl(productModel.videoUrl![0] as String);
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 4.0,top: 8,right: 4),
                                            child: Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: Color(0xffd4e8ff),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: productModel.videoUrl !=null ? Icon(Icons.play_arrow) : SizedBox(),
                                                )),
                                          ),
                                        ),
                                        if(productModel.videoUrl!=null && productModel.videoUrl!.length>1)GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              current=6;
                                              if(controller!=null) controller!.loadUrl(productModel.videoUrl![1] as String);
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 4.0,top: 8,right: 4),
                                            child: Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: Color(0xffd4e8ff),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: productModel.videoUrl !=null ? Icon(Icons.play_arrow) : SizedBox(),
                                                )),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                                Expanded(child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xffd4e8ff),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: current<5 ? Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: productModel.photoUrl !=null ? LoadImage(path: productModel.photoUrl![current] as String) : SizedBox(),
                                    ): Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: productModel.videoUrl !=null ? WebView(initialUrl: productModel.videoUrl![current-5] as String,onWebViewCreated: (WebViewController webViewController) {
                                        controller=webViewController;
                                      },) : SizedBox(),
                                    )),                                )
                              ],
                            ),
                          ): Container(height: 250, child: Center(child: Text(AppLocalizations.of(context).imageNotAvailable)),),

                        ],
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                  color: Color(0xfff1f7ff),
                  borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(child: MyTitle(text: '${productModel.name}')),
                            MySubTitle(
                                text:
                                    '${productModel.desc ?? 0} '),

                            if(productModel.offer!=productModel.price)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text('${AppLocalizations.of(context).price}: $currency ${productModel.offer ?? 0.0}',),
                              ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Visibility(
                                visible:
                                (Provider.of<UserProvider>(context, listen: false)
                                    .userModel!
                                    .role ==
                                    client),
                                child: TextButton(
                                    onPressed: () {
                                      if (quantity > 0) {
                                        Provider.of<CartProvider>(context,
                                            listen: false)
                                            .minusFromCart(productModel)
                                            .then((value) {
                                          setState(() {
                                            quantity--;
                                            if (quantity < 1) {
                                              Provider.of<CartProvider>(context, listen: false).delete(currentString);
                                            }
                                          });
                                        });
                                      }
                                    },
                                    child: Row(
                                      children: const [
                                        Icon(Icons.remove),
                                      ],
                                    )),
                              ),
                              Visibility(
                                visible:
                                (Provider.of<UserProvider>(context, listen: false)
                                    .userModel!
                                    .role ==
                                    client),
                                child: FutureBuilder(
                                  key: Key('${quantity}'),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DatabaseEvent> snapshot) {
                                    if (snapshot.hasData) {
                                      var ref = snapshot.data!;
                                      if (ref.snapshot.children.isNotEmpty) {
                                        var firstWhere = ref.snapshot.children
                                            .map((e) => e.value)
                                            .firstWhere(
                                                (element) =>
                                            (element as Map<dynamic,
                                                dynamic>?)?['productKey'] ==
                                                productModel.key,
                                            orElse: () => null)
                                        as Map<dynamic, dynamic>?;
                                        if (firstWhere != null) {
                                          CartModel cartModel =
                                          CartModel.fromMap(firstWhere);
                                          quantity = cartModel.quantity!;
                                          currentString = cartModel.key!;
                                        }
                                      }
                                      return Text('${quantity}');
                                    } else {
                                      return Text('${quantity}');
                                    }
                                  },
                                  future: FirebaseDatabase.instance
                                      .ref()
                                      .child('carts')
                                      .orderByChild('buyerUID')
                                      .equalTo(FirebaseAuth.instance.currentUser!.uid)
                                      .once(),
                                ),
                              ),
                              Visibility(
                                visible:
                                (Provider.of<UserProvider>(context, listen: false)
                                    .userModel!
                                    .role ==
                                    client),
                                child: TextButton(
                                    onPressed: () {
                                      Provider.of<CartProvider>(context, listen: false)
                                          .addToCart(productModel)
                                          .then((value) {
                                        setState(() {
                                          quantity++;
                                        });
                                      });
                                    },
                                    child: Row(
                                      children: const [Icon(Icons.add)],
                                    )),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text('${AppLocalizations.of(context).price}: $currency ${productModel.price ?? 0.0}',style: TextStyle(decoration: productModel.offer!=productModel.price ? TextDecoration.lineThrough : TextDecoration.none),),
                          ),
                        ],
                      ),
                    ],
                  ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

///my-product list unit

/// carts list unit
class CartListUnit extends StatelessWidget {
  final CartModel cartModel;

  const CartListUnit({Key? key, required this.cartModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carts = Provider.of<CartProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffb3d6ff),
          borderRadius: BorderRadius.circular(20),
        ),
        child: FutureBuilder(
          future: firebaseDatabase
              .ref(productsReferenceWithCurrency)
              .child(currency)
              .child(cartModel.productKey!)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
            final hasData = snapshot.hasData && snapshot.data != null;

            ProductModel p = !hasData
                ? ProductModel(currency: currency)
                : ProductModel.fromMap(
                    snapshot.data?.value as Map<dynamic, dynamic>);

            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 8,
                ),
                SizedBox(
                    width: 100,
                    height: 100,
                    child: p.photoUrl!=null ? LoadImage(path: p.photoUrl![0] as String) : SizedBox()),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyTitle(text: '${p.name}'),
                        TextButton(
                            onPressed: () async {
                              await showDialog<void>(
                                context: context,
                                barrierDismissible: true,
                                // false = user must tap button, true = tap outside dialog
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title:  Text(AppLocalizations.of(context).confirm),
                                    content:  Text(
                                        '${AppLocalizations.of(context).areYousuretoremovethisitemfromcart}?'),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: Text(AppLocalizations.of(context).no),
                                        onPressed: () {
                                          Navigator.of(dialogContext)
                                              .pop(); // Dismiss alert dialog
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Text(AppLocalizations.of(context).yes),
                                        onPressed: () {
                                          Navigator.of(dialogContext)
                                              .pop(); // Dismiss alert dialog
                                          carts
                                              .delete(cartModel.key!)
                                              .then((value) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar( SnackBar(
                                                    content: Text(AppLocalizations.of(context).removed)));
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Icon(Icons.delete_forever)),
                      ],
                    ),
                    MySubTitle(
                        text: '${AppLocalizations.of(context).price}: $currency ${cartModel.price ?? 0.0}'),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                            onPressed: () {
                              cartModel.quantity = cartModel.quantity! + 1;
                              cartModel.price = cartModel.quantity! * p.price!;
                              carts.update(cartModel);
                            },
                            child: const Icon(Icons.add)),
                        Text(NumberFormat('000').format(cartModel.quantity)),
                        TextButton(
                            onPressed: () {
                              cartModel.quantity = cartModel.quantity! - 1;
                              cartModel.price = cartModel.quantity! * p.price!;
                              if (cartModel.quantity! <= 0) {
                                carts.delete(cartModel.key!);
                              } else {
                                carts.update(cartModel);
                              }
                            },
                            child: const Icon(Icons.remove)),
                      ],
                    ),
                  ],
                ))
              ],
            );
          },
        ),
      ),
    );
  }
}

/// orders list unit
class OrdersListUnit extends StatelessWidget {
  final OrderModel orderModel;

  const OrdersListUnit({Key? key, required this.orderModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrdersProvider orderProvider=Provider.of<OrdersProvider>(context,listen: false);
    UserProvider userProvider=Provider.of<UserProvider>(context,listen: false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: firebaseDatabase
            .ref(productsReferenceWithCurrency)
            .child(currency)
            .child(orderModel.productKey!)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
          final hasData = snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.value != null;

          ProductModel p = !hasData
              ? ProductModel(currency: currency)
              : ProductModel.fromMap(
                  snapshot.data?.value as Map<dynamic, dynamic>);

          return FutureBuilder(
            builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if (!snapshot.hasData) {
                return SizedBox();
              }
              UserModel model = UserModel.formMap(
                  snapshot.data?.snapshot.value as Map<dynamic, dynamic>);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(
                          width: 144,
                          height: 144,
                          child: LoadImage(path: p.photoUrl![0] as String)),
                      SizedBox(height: 20),
                      if(userProvider.userModel?.role=='client')GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShopScreen(
                                        uid: orderModel.sellerUID!,
                                      )));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.shopify),
                            Text(AppLocalizations.of(context).orderAgain),
                          ],
                        ),
                      )
                    ],
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyTitle(text: '${AppLocalizations.of(context).item}: ${p.name}'),
                      MySubTitle(
                          text: '${AppLocalizations.of(context).total}: $currency ${orderModel.price ?? 0.0}'),
                      if(model.role=='client')MySubTitle(
                          text: '${AppLocalizations.of(context).shopName}:${model.name ?? AppLocalizations.of(context).shopName}'),
                      if(model.role=='client')FutureBuilder(
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return SizedBox();
                            return MySubTitle(
                                text:
                                    '${AppLocalizations.of(context).shopAddress}:${snapshot.data ?? AppLocalizations.of(context).shopAddress}');
                          },
                          future: _getUserLocation(
                              model.latitude ?? 0, model.longitude ?? 0)),
                      if(userProvider.userModel!.role=='serviceProvider')MySubTitle(
                          text:
                          '${AppLocalizations.of(context).orderno}: ${orderProvider.ordersList.indexOf(orderModel)+1}'),
                      if(userProvider.userModel!.role=='serviceProvider')MySubTitle(
                          text:
                          '${AppLocalizations.of(context).areaStreet}: ${orderModel.addressModel?.area ?? AppLocalizations.of(context).areaStreet}'),
                      if(userProvider.userModel!.role=='client')
                        FutureBuilder(builder: (context,value) {
                          if (!snapshot.hasData) return SizedBox();
                          return MySubTitle(
                              text:
                              '${AppLocalizations
                                  .of(context)
                                  .areaStreet}: ${value.data}');
                        },future: userProvider.getArea(model.uid!),),
                      if(userProvider.userModel!.role=='client')
                        FutureBuilder(builder: (context,value) {
                          if (!snapshot.hasData) return SizedBox();
                          return MySubTitle(
                              text:
                              '${AppLocalizations.of(context).rating}: ${value.data}');
                        },future: userProvider.getRating(model.uid!),),
                      MySubTitle(
                          text:
                              '${AppLocalizations.of(context).paymentMethod}: ${orderModel.paymentMethod=='COD' ? AppLocalizations.of(context).cashOnDelivery : orderModel.paymentMethod ?? AppLocalizations.of(context).cash}'),
                      MySubTitle(
                          text:
                              '${AppLocalizations.of(context).paymentStatus}:  ${orderModel.paymentStatus=='Pending' ? AppLocalizations.of(context).pending : orderModel.paymentStatus ?? AppLocalizations.of(context).pending}'),
                      MySubTitle(
                          text:
                              '${AppLocalizations.of(context).orderQuantity}:  ${orderModel.quantity ?? '0'}'),
                      MySubTitle(
                          text:
                              '${AppLocalizations.of(context).orderStatus}:  ${orderModel.shippingStatus=='Pending' ? AppLocalizations.of(context).pending : orderModel.shippingStatus=='Shipped'? AppLocalizations.of(context).shipped : AppLocalizations.of(context).shipped}'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (orderModel.date != null)
                            Text(DateFormat('dd/MM/yy hh:mm a')
                                .format(orderModel.date!)),
                          IconButton(
                              onPressed: () {
                                if (Provider.of<UserProvider>(context,
                                            listen: false)
                                        .userModel
                                        ?.role ==
                                    client) {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (ctx) {
                                    return OrderDetailScreenClient(
                                      orderModel: orderModel,
                                    );
                                  }));
                                } else {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (ctx) {
                                    return OrderDetailScreenProvider(
                                      orderModel: orderModel,navigationType: 'serviceProvider',
                                    );
                                  }));
                                }
                              },
                              icon: const Icon(Icons.arrow_forward)),
                        ],
                      ),
                      if (orderModel.shippingStatus == 'Delivered' && userProvider.userModel?.role=='client')
                        RatingBar(
                          initialRating: orderModel.rating?.toDouble() ?? 0,
                          direction: Axis.horizontal,
                          itemSize: 25,
                          allowHalfRating: false,
                          itemCount: 5,
                          ratingWidget: RatingWidget(
                            full: Image.asset('assets/yellowheart.png'),
                            empty: Image.asset('assets/whiteheart.png'),
                            half: SizedBox(),
                            // half: _image('assets/heart_half.png'),
                            // empty: _image('assets/heart_border.png'),
                          ),
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          onRatingUpdate: (rating) {
                            orderModel.rating = rating.toInt();
                            Provider.of<OrdersProvider>(context, listen: false)
                                .update(orderModel);
                          },
                        )
                    ],
                  ))
                ],
              );
            },
            future: FirebaseDatabase.instance
                .ref()
                .child('users')
                .child(orderModel.sellerUID!)
                .once(),
          );
        },
      ),
    );
  }

  Future<String?> _getUserLocation(double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    return placemarks[0].locality;
  }
}

class OrdersListUnitProvider extends StatelessWidget {
  final OrderModel orderModel;

  const OrdersListUnitProvider({Key? key, required this.orderModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: firebaseDatabase
            .ref(productsReferenceWithCurrency)
            .child(currency)
            .child(orderModel.productKey!)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
          final hasData = snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.value != null;

          ProductModel p = !hasData
              ? ProductModel(currency: currency)
              : ProductModel.fromMap(
                  snapshot.data?.value as Map<dynamic, dynamic>);

          return FutureBuilder(
            builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if (!snapshot.hasData) {
                return SizedBox();
              }
              UserModel model = UserModel.formMap(
                  snapshot.data?.snapshot.value as Map<dynamic, dynamic>);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(
                          width: 144,
                          height: 144,
                          child: LoadImage(path: p.photoUrl![0] as String)),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShopScreen(
                                        uid: orderModel.sellerUID!,
                                      )));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.shopify),
                            Text(AppLocalizations.of(context).orderAgain),
                          ],
                        ),
                      )
                    ],
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyTitle(text: '${AppLocalizations.of(context).item}: ${p.name}'),
                      MySubTitle(
                          text: '${AppLocalizations.of(context).total}: $currency ${orderModel.price ?? 0.0}'),
                      MySubTitle(
                          text: '${AppLocalizations.of(context).buyerName}:${model.name ?? AppLocalizations.of(context).buyerName}'),
                      FutureBuilder(
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return SizedBox();
                            return MySubTitle(
                                text:
                                    '${AppLocalizations.of(context).buyerAddress}:${snapshot.data ?? AppLocalizations.of(context).address}');
                          },
                          future: _getUserLocation(
                              model.latitude ?? 0, model.longitude ?? 0)),
                      MySubTitle(
                          text:
                              '${AppLocalizations.of(context).paymentMethod}: ${orderModel.paymentMethod ?? AppLocalizations.of(context).cash}'),
                      MySubTitle(
                          text:
                              '${AppLocalizations.of(context).paymentStatus}:  ${orderModel.paymentStatus ?? AppLocalizations.of(context).pending}'),
                      MySubTitle(
                          text:
                              '${AppLocalizations.of(context).orderQuantity}:  ${orderModel.quantity ?? '0'}'),
                      MySubTitle(
                          text:
                              '${AppLocalizations.of(context).orderStatus}:  ${orderModel.shippingStatus ?? AppLocalizations.of(context).pending}'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (orderModel.date != null)
                            Text(DateFormat('dd/MM/yy hh:mm a')
                                .format(orderModel.date!)),
                          IconButton(
                              onPressed: () {
                                if (Provider.of<UserProvider>(context,
                                            listen: false)
                                        .userModel
                                        ?.role ==
                                    client) {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (ctx) {
                                    return OrderDetailScreenClient(
                                      orderModel: orderModel,
                                    );
                                  }));
                                } else {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (ctx) {
                                    return OrderDetailScreenProvider(
                                      orderModel: orderModel, navigationType: 'serviceProvider',
                                    );
                                  }));
                                }
                              },
                              icon: const Icon(Icons.arrow_forward)),
                        ],
                      ),
                      if (orderModel.shippingStatus == 'Shipped')
                        RatingBar(
                          initialRating: orderModel.rating?.toDouble() ?? 0,
                          direction: Axis.horizontal,
                          itemSize: 25,
                          allowHalfRating: false,
                          itemCount: 5,
                          ratingWidget: RatingWidget(
                            full: Image.asset('assets/yellowheart.png'),
                            empty: Image.asset('assets/whiteheart.png'),
                            half: SizedBox(),
                            // half: _image('assets/heart_half.png'),
                            // empty: _image('assets/heart_border.png'),
                          ),
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          onRatingUpdate: (rating) {
                            orderModel.rating = rating.toInt();
                            Provider.of<OrdersProvider>(context, listen: false)
                                .update(orderModel);
                          },
                        )
                    ],
                  ))
                ],
              );
            },
            future: FirebaseDatabase.instance
                .ref()
                .child('users')
                .child(orderModel.buyerUID!)
                .once(),
          );
        },
      ),
    );
  }

  Future<String?> _getUserLocation(double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    return placemarks[0].locality;
  }
}

///if there is no data in list
class Empty extends StatelessWidget {
  const Empty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(AppLocalizations.of(context).datanotAvailable),
      ),
    );
  }
}

/// Customized Text to set Label
class Label extends StatelessWidget {
  const Label(
      {Key? key,
      required this.text,
      this.fontSize = 14.0,
      this.style,
      this.fontWeight = FontWeight.bold})
      : super(key: key);

  final double fontSize;
  final FontWeight fontWeight;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            text,
            style: style ??
                GoogleFonts.montserrat(
                    fontWeight: fontWeight,
                    fontSize: fontSize,
                    color: Theme.of(context).colorScheme.secondary),
          )),
    );
  }
}

///below widget is used to set location
///
class SetLocationWidget extends StatelessWidget {
  const SetLocationWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).updatingYourLocation)));
          final perm = await Geolocator.checkPermission();
          switch (perm) {
            case LocationPermission.always:
            case LocationPermission.whileInUse:
              // TODO: Handle this case.
              break;
            case LocationPermission.denied:
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text(AppLocalizations.of(context).locationPermissionRequired)));
              await Geolocator.requestPermission();
              break;

            case LocationPermission.deniedForever:

            case LocationPermission.unableToDetermine:
              Fluttertoast.showToast(
                  msg: AppLocalizations.of(context).pleaseAllowPermission);
              await Geolocator.openAppSettings();

              break;
          }

          final position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          var mapModel = MapModel.fromMap(position.toJson());
          Provider.of<RunningStatusProvider>(context, listen: false).mapModel =
              mapModel;
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return GoogleMapView();
          }));

          return;
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.my_location),
          ],
        ));
  }
}

class FutureText extends StatelessWidget {
  final Future<DataSnapshot> future;
  final String label;
  final TextStyle? style;

  const FutureText(
      {Key? key, required this.future, this.label = '', this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyShimmer(
              child: MyShimmerSkeleton(
            height: 10,
          ));
        }
        if ((!snapshot.hasData) || snapshot.data == null) {
          return Text(
            '-',
            style: style,
          );
        }
        if (snapshot.data!.value == null) {
          return Text('-', style: style);
        }
        {
          return Text('$label ${snapshot.data!.value}', style: style);
        }
      },
    );
  }
}
