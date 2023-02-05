import 'dart:async';

import 'package:WeServeU/widget/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../data/constants.dart';
import '../model/product_model.dart';
import '../providers/product_provider.dart';
import '../screen/add_product_screen.dart';

class MyProductListUnit extends StatefulWidget {

  const MyProductListUnit({Key? key, required this.productModel})
      : super(key: key);

  final ProductModel productModel;

  State<MyProductListUnit> createState() => _MyProductListUniState(productModel);
}

class _MyProductListUniState extends State<MyProductListUnit> {

  ProductModel productModel;
  int current=0;
  WebViewController? controller;
  @override
  Widget build(BuildContext context) {
    Widget widget;
    if(productModel.videoUrl!=null && current > 5) widget=WebView(initialUrl: productModel.videoUrl![current-5] as String);
    if(productModel.photoUrl==null) current=5;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffb3d6ff),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
           Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  productModel.photoUrl !=null || productModel.videoUrl!=null ? SizedBox(
                    height: 250,
                    child: Row(
                      children: [
                        SingleChildScrollView(
                          child:  Column(
                            children: [
                              productModel.photoUrl!=null && productModel.photoUrl!.isNotEmpty ? GestureDetector(
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
                              if(productModel.photoUrl!=null && productModel.photoUrl!.length > 1)  GestureDetector(
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
                              if(productModel.photoUrl!=null && productModel.photoUrl!.length > 2) GestureDetector(
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
                              if(productModel.photoUrl!=null && productModel.photoUrl!.length > 3) GestureDetector(
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
                              if(productModel.photoUrl!=null && productModel.photoUrl!.length > 4)GestureDetector(
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
                            )),
                        )
                      ],
                    ),
                  ): Container(height: 250, child: Center(child: Text(AppLocalizations.of(context).imageNotAvailable)),),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0,top: 8,right: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffd4e8ff),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              MyTitle(
                                  text: '$currency ${productModel.price ?? 0.0}'),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        num quantity = productModel.quantity ?? 0;
                                        quantity++;
                                        productModel.quantity = quantity;
                                        Provider.of<ProductProvider>(context, listen: false)
                                            .update(productModel.toMap());
                                      },
                                      child: const Icon(Icons.add)),
                                  Text(NumberFormat('000')
                                      .format(productModel.quantity ?? 0)),
                                  TextButton(
                                      onPressed: () {
                                        num quantity = productModel.quantity ?? 0;
                                        if (quantity > 0) {
                                          quantity--;
                                          productModel.quantity = quantity;
                                          Provider.of<ProductProvider>(context,
                                              listen: false)
                                              .update(productModel.toMap());
                                        }
                                      },
                                      child: const Icon(Icons.remove)),
                                ],
                              ),

                            ],
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                MyTitle(text: '${productModel.name ?? AppLocalizations.of(context).product }'),
                                MySubTitle(
                                    text: '${AppLocalizations.of(context).productDescription}: ${productModel.desc ?? AppLocalizations.of(context).productDescription}'),
                                MySubTitle(
                                    text: '${AppLocalizations.of(context).quantity}: ${productModel.quantity ?? 0} ${AppLocalizations.of(context).liters}'),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: MySubTitle(
                        text: productModel.live ?? false ? AppLocalizations.of(context).published : AppLocalizations.of(context).draft,
                        color: productModel.live ?? false ? Colors.green : Colors.red,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Provider.of<ProductProvider>(context, listen: false)
                              .productModel = productModel;
                          Navigator.pushNamed(context, AddProductScreen.routeName);
                        },
                        child: Image.asset('assets/edit.png')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

  _MyProductListUniState(this.productModel);
}

