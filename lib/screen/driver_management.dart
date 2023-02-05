import 'package:WeServeU/model/user_model.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class DriverManagement extends StatefulWidget {
  const DriverManagement({Key? key}) : super(key: key);

  @override
  State<DriverManagement> createState() => _DriverManagementState();
}

class _DriverManagementState extends State<DriverManagement> {
  String key='';
  @override
  Widget build(BuildContext context) {
    var local=AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(local.driver),
        backgroundColor: Color(0xFF5E7AF3),
        actions: [
          GestureDetector(
            onTap: (){
              addDriver(label: local.driverPhone,code: 'JO',onClick: (value){
                FirebaseDatabase.instance.ref('users').orderByChild('mobile').equalTo(value).once().then((value){
                  DataSnapshot snap =value.snapshot.children.first;
                  UserModel model=UserModel.formMap(snap.value as Map);
                  model.shopId=FirebaseAuth.instance.currentUser!.uid;
                  FirebaseDatabase.instance.ref('users').child(model.uid!).set(model.toMap()).then((value){
                    setState(() {
                      key;
                    });
                    Navigator.pop(context);
                  });
                });
              });
            },
              child: Icon(Icons.add)),
          SizedBox(width: 16,),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(local.yourDrivers,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
            ),
          ),
          Expanded(child: FutureBuilder(key: Key(key),builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator());
            }else{
              List<UserModel> driverList=[];
              for(DataSnapshot snap in snapshot.data!.snapshot.children){
                UserModel driver=UserModel.formMap(snap.value as Map);
                driverList.add(driver);
              }
              return ListView.builder(itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset('stearing.png',height: 50,width: 50,),
                              SizedBox(width: 8,),
                              Expanded(child: Text(driverList[index].name ?? local.driver,style: TextStyle(fontWeight: FontWeight.bold))),
                              GestureDetector(
                                  onTap: (){
                                    driverList[index].shopId='';
                                    FirebaseDatabase.instance.ref('users').child(driverList[index].uid!).remove().then((value){
                                      setState(() {
                                        key;
                                      });
                                    });
                                  },
                                  child: Icon(Icons.delete)),
                            ],
                          ),
                          SizedBox(height: 16,),
                          Divider(),
                          Container(margin: EdgeInsets.all(8),width: double.infinity,child: Text(local.isCustomerContactVisible,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),)),
                          Row(
                            children: [
                              Expanded(child: GestureDetector(onTap: (){
                                driverList[index].notifyAllowed='Allowed';
                                FirebaseDatabase.instance.ref('users').child(driverList[index].uid!).set(driverList[index].toMap()).then((value){
                                  setState(() {
                                    key;
                                  });
                                });
                              },child: Container(margin: EdgeInsets.all(8),decoration: BoxDecoration(color: driverList[index].notifyAllowed =='Allowed' ? Colors.blue : Colors.blue.shade200,borderRadius: BorderRadius.circular(8)),height: 50,child: Center(child: Text(local.visible,style: TextStyle(fontWeight: FontWeight.bold),),),))),
                              Expanded(child: GestureDetector(onTap: (){
                                driverList[index].notifyAllowed='Not Allowed';
                                FirebaseDatabase.instance.ref('users').child(driverList[index].uid!).set(driverList[index].toMap()).then((value){
                                  setState(() {
                                    key;
                                  });
                                });
                              },child: Container(margin: EdgeInsets.all(8),decoration: BoxDecoration(color: driverList[index].notifyAllowed !='Allowed' ? Colors.blue : Colors.blue.shade200,borderRadius: BorderRadius.circular(8)),height: 50,child: Center(child: Text(local.invisible,style: TextStyle(fontWeight: FontWeight.bold),),),))),
                            ],
                          )
                        ],
                      )),
                    ),

                  ],
                );
              },itemCount: driverList.length,);
              return Center(child: Text(local.noDriversFound));
            }
          },future: FirebaseDatabase.instance.ref('users').orderByChild('shopId').equalTo(FirebaseAuth.instance.currentUser!.uid).once(),))
        ],
      ),
    );
  }
  addDriver({required String label, required Function(String) onClick, required String code}) async {
    final controller = TextEditingController();
    var country=await getCountryByCountryCode(context, code);
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(label),
          content: Row(
            key: Key(country!.callingCode),
            children: [
              GestureDetector(onTap: () async{
                final Map<String, dynamic> initData = {};
                  final currentcountry = await showCountryPickerSheet(
                    context,
                  );
                  if (currentcountry != null) {
                    setState(() {
                      country = currentcountry;
                    });
                    Navigator.pop(context);
                    this.addDriver(label: label, onClick: onClick,code:country?.countryCode ??'JO');
                  }
        },child: Text(country!.callingCode)),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: controller,
                      decoration: InputDecoration(
                          labelText: label, border: const OutlineInputBorder()),
                    )),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context).cancel)),
            ElevatedButton(
                onPressed: () {
                  onClick(country!.callingCode + controller.text);
                },
                child: Text(AppLocalizations.of(context).addDriver))
          ],
        );

      },
    );
  }
}
