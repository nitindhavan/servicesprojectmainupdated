import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/offer_model.dart';
import '../providers/user_provider.dart';
class OfferScreen extends StatefulWidget {
  const OfferScreen({Key? key,required this.uid}) : super(key: key);
  final String uid;

  @override
  State<OfferScreen> createState() => _OfferScreenState(uid);
}

class _OfferScreenState extends State<OfferScreen> {
  bool isDeleteMode=false;
  String? coverImage;
  String key='';
  List<String> deleteList=[];
  String uid;
  _OfferScreenState(this.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if(snapshot.hasData){
                    List<OfferModel> offerList=[];
                    for(DataSnapshot snap in snapshot.data!.snapshot.children){
                      OfferModel offerModel=OfferModel.fromMap(snap.value as Map);
                      offerList.add(offerModel);
                    }
                    return ListView.builder(itemBuilder: (BuildContext context, int index) {
                      print(deleteList.contains(offerList[index]));
                      return Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  isDeleteMode=!isDeleteMode;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                height:200,
                                child: Image.network(offerList[index].imageUrl!),
                              ),
                            ),
                          ),
                          if(isDeleteMode)Checkbox(value: deleteList.contains(offerList[index].key), onChanged: (value){
                            setState(() {
                              if(value==true){
                                deleteList.add(offerList[index].key!);
                                print(deleteList.contains(offerList[index]));
                              }else{
                                deleteList.remove(offerList[index].key!);
                              }
                            });
                          }),
                        ],
                      );
                    },itemCount: offerList.length,);
                  }else{
                    return Center(child: CircularProgressIndicator());
                  }
                },stream: FirebaseDatabase.instance.ref('offers').orderByChild('shopUid').equalTo(uid).onValue,),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: () async {
                          final provider = Provider.of<UserProvider>(context,
                              listen: false);
                          final sm = ScaffoldMessenger.of(context);
                          final result = await FilePicker.platform.pickFiles(
                              dialogTitle: "Offer Image",
                              type: FileType.image,
                              allowCompression: true,
                              allowMultiple: false);
                          if (result != null && result.files.isNotEmpty) {
                            setState(() {
                              coverImage = result.paths.first;
                            });
                            final res = await provider
                                .addOffer(result.paths.first);
                            setState(() {
                              key;
                            });
                            coverImage = null;
                            if (res.isNotEmpty) {
                              sm.showSnackBar(SnackBar(content: Text(res)));
                            }
                          }
                        },
                        child: Container(height: 60,child: Center(child: Text('Add Offer',)),color: Colors.blue.shade100,margin: EdgeInsets.all(8),)),
                  ),
                  if(isDeleteMode)IconButton(onPressed: () async{
                    for(String mString in deleteList){
                      await FirebaseDatabase.instance.ref('offers').child(mString).remove();
                    }
                    setState(() {
                      isDeleteMode=false;
                    });
                  }, icon: Icon(Icons.delete)),
                  SizedBox(width: 8,),
                ],
              ),

            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Offers'),
        backgroundColor: Color(0xff5e7af3),
      ),
    );
  }
}
