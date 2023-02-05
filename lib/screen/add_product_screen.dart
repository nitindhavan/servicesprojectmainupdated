import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/constants.dart';
import '../providers/product_provider.dart';
import '../widget/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);
  static const routeName = '/add-product-screen';

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
       Map<String, dynamic> initData ={};

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  void initState() {
    getInitData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var local=AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(local.addNewProduct),
        backgroundColor: Color(0xff5e7af3),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                  onPressed: () async {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true,
                      // false = user must tap button, true = tap outside dialog
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title:  Text(local.confirm),
                          content: Text(local.areyousuretodeletethisitemfromourdatabase),
                          actions: <Widget>[
                            ElevatedButton(
                              child: Text(local.no),
                              onPressed: () {
                                Navigator.of(dialogContext)
                                    .pop(); // Dismiss alert dialog
                              },
                            ),
                            ElevatedButton(
                              child: Text(local.yes),
                              onPressed: () {
                                Provider.of<ProductProvider>(context, listen: false).delete();

                                Navigator.of(dialogContext)
                                    .pop();
                                Navigator.of(dialogContext)
                                    .pop(); // Dismiss alert dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(local.remove,style: TextStyle( fontSize: 20),)),
            ),
          ),

          Container(margin: EdgeInsets.all(16),width: double.infinity,child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(local.addImage,style: TextStyle(color: Colors.black,fontSize: 16),textAlign: TextAlign.start,),
              GestureDetector(onTap:(){
                setState(() {
                  initData['photoUrl']=null;
                  Provider.of<ProductProvider>(context,listen: false).update(initData);
                  initData;
                });

              },child: Text(local.deleteImage,style: TextStyle(color: Colors.redAccent,fontSize: 16),textAlign: TextAlign.start,)),
            ],
          )),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _form,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                            productPicture(context,0),
                            productPicture(context,1),
                            productPicture(context,2),
                            productPicture(context,3),
                            productPicture(context,4),
                          ],),
                        ),
                      ),
                      const Divider(),
                      Container(margin: EdgeInsets.all(16),width: double.infinity,child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(local.addVideo,style: TextStyle(color: Colors.black,fontSize: 16),textAlign: TextAlign.start,),
                          GestureDetector(onTap:(){

                            setState(() {
                              initData['videoUrl']=null;
                              Provider.of<ProductProvider>(context,listen: false).update(initData);
                            });

                          },child: Text(local.deleteVideos,style: TextStyle(color: Colors.redAccent,fontSize: 16),textAlign: TextAlign.start,)),
                        ],
                      )),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              productVideo(context,0),
                              productVideo(context,1),
                            ],),
                        ),
                      ),
                      textInput(key: 'name', hint: local.enternameoftheproduct),
                      textInput(key: 'desc', hint: local.productDescription),
                      numberInput(
                          key: 'quantity', hint: local.enterQuantityAvailable),
                      numberInput(
                          key: 'price', hint: '${local.enterpriceperpiecein} $currency'),
                      numberInput(
                          key: 'offer', hint: local.enterOfferPrice),
                      textInput(
                          key: 'type', hint: local.enterProductType),
                      const Divider(),
                      ListTile(
                        title: Text(local.publish),
                        subtitle:  Text(local.onlypublishedproductswillbeavailabletoclients),
                        trailing: Switch(value: initData['live']??false, onChanged: (v){
                          if(v){
                            _form.currentState!.save();
                            if (_form.currentState!.validate()) {
                              if (initData['type'] == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                     SnackBar(
                                        content: Text(local.pleaseselectproducttype)));
                              } else{
                                initData['live']=v;
                                updateUI();
                              }
                            }
                          }else{
                            initData['live']=v;
                            updateUI();
                          }


                        }),
                      ),

                      const Divider(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(local.cancel),
                  )),
              ElevatedButton(
                  onPressed: () async {
                    _form.currentState!.save();
                    if (_form.currentState!.validate()) {
                      if (initData['type'] == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(local.pleaseselectproducttype)));
                      } else {
                        Provider.of<ProductProvider>(context, listen: false)
                            .update(initData)
                            .then((value) {
                          if (value == null) {
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(value.toString())));
                          }
                        });
                      }
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(local.save),
                  ))

            ],
          )
        ],
      ),
    );
  }

  Padding textInput({required String key, required String hint}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        key:Key('${initData[key]??''}') ,
        initialValue: '${initData[key]??''}',
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        validator: (v) {
          if (v!.isEmpty) {
              return hint;
          }
          return null;
        },
        onSaved: (v) {
          initData[key] = v!;
        },
        style: const TextStyle(
            color: Colors.blueGrey, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelText: hint,
          border: const OutlineInputBorder(),
          hintStyle:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Padding numberInput({required String key, required String hint}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        key:Key('${initData[key]??''}') ,
        initialValue: '${initData[key]??''}',
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        validator: (v) {
          if(key=='offer'){
            if(initData['offer']==null)initData['offer']=initData['price'];
            return null;
          };
          if (v!.isEmpty) {
            return hint;
          }
          return null;
        },
        onSaved: (v) {
          initData[key] = double.tryParse(v!);
        },
        style: const TextStyle(
            color: Colors.blueGrey, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelText: hint,
          border: const OutlineInputBorder(),
          hintStyle:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  productPicture(BuildContext context,int index) {
    if(initData['photoUrl']==null) initData['photoUrl']=List.empty(growable: true);
    return Center(
      child: Stack(
        children: [
          Consumer<ProductProvider>(builder: (context, provider, _) {
            return Container(
              margin: EdgeInsets.all(16),
              height: 144.0,
              width: 144.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: initData['photoUrl'].length-1 < index && !provider.uploading[index]
                    ?  MyCustomCard(
                        radius: 0.0,
                        padding: 8,
                        margin: 0.0,
                        child: FittedBox(child: Text(AppLocalizations.of(context).selectPhoto)))
                    : provider.uploading[index]
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : LoadImage(
                            path: initData['photoUrl'][index],
                          ),
              ),
            );
          }),
          Positioned(
              bottom: -16,
              right: -16,
              child: MyCustomCard(
                  radius: 32.0,
                  padding: 0,
                  margin: 0,
                  color: Colors.white,
                  child: IconButton(
                      onPressed: (){
                        fileFunction();
                      },
                      icon:   Icon(
                        Icons.camera_alt,
                        color: Theme.of(context).primaryColor,
                      ))))
        ],
      ),
    );
  }
  productVideo(BuildContext context,int index) {
    if(initData['videoUrl']==null) initData['videoUrl']=List.empty(growable: true);
      return Center(
        child: Stack(
          children: [
            Consumer<ProductProvider>(builder: (context, provider, _) {
              return Container(
                margin: EdgeInsets.all(16),
                height: 144.0,
                width: 144.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: initData['videoUrl'].length-1 < index && !provider.uploadingVideo[index]
                      ?  MyCustomCard(
                      radius: 0.0,
                      padding: 8,
                      margin: 0.0,
                      child: FittedBox(child: Text(AppLocalizations.of(context).selectVideo)))
                      : provider.uploadingVideo[index]
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : WebView(initialUrl:initData['videoUrl'][index],),
                ),
              );
            }),
            Positioned(
                bottom: -16,
                right: -16,
                child: MyCustomCard(
                    radius: 32.0,
                    padding: 0,
                    margin: 0,
                    color: Colors.white,
                    child: IconButton(
                        onPressed: (){
                          fileFunctionVideo();
                        },
                        icon:  Icon(
                          Icons.video_call_rounded,
                          color: Theme.of(context).primaryColor,
                        ))))
          ],
        ),
      );
    }

  void fileFunction() async {
    final res = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);
    if (res != null && res.paths.isNotEmpty) {
      if(initData['photoUrl']==null)initData['photoUrl']=[];
      var list=initData['photoUrl'].toList();
      list.add(await Provider.of<ProductProvider>(context, listen: false)
              .setPhoto(res.paths.first!,list.length));
      initData['photoUrl']=list;
      print(initData);
      updateUI();
    }
  }
  void fileFunctionVideo () async {
    final res = await FilePicker.platform
             .pickFiles(allowMultiple: false, type: FileType.video);
         if (res != null && res.paths.isNotEmpty) {
           if(initData['videoUrl']==null)initData['videoUrl']=[];
           var list=initData['videoUrl'].toList();
           list.add(await Provider.of<ProductProvider>(context, listen: false)
               .setVideo(res.paths.first!,list.length));
           initData['videoUrl']=list;
           print(initData);
           updateUI();
         }
       }

  updateUI() => setState(() {});

    getInitData() {
    Future.delayed(const Duration(seconds: 0)).whenComplete(() {
      if (Provider.of<ProductProvider>(context, listen: false).productModel !=
          null) {

        setState(() {
          initData=(Provider.of<ProductProvider>(context, listen: false)
              .productModel!
              .toMap());
          print(initData);
        });

      }else{
        getInitData();
      }
    });
  }
}
