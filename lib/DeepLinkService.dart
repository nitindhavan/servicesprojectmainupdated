import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

import 'data/constants.dart';
import 'model/user_model.dart';

class DeepLinkService {
  DeepLinkService._();
  static DeepLinkService? _instance;

  static DeepLinkService? get instance {
    _instance ??= DeepLinkService._();
    return _instance;
  }

  ValueNotifier<String> referrerCode = ValueNotifier<String>('');

  final dynamicLink = FirebaseDynamicLinks.instance;

  Future<void> handleDynamicLinks() async {
    //Get initial dynamic link if app is started using the link
    final data = await dynamicLink.getInitialLink();
    if (data != null) {
      _handleDeepLink(data);
    }

    //handle foreground
    dynamicLink.onLink.listen((event) {
      _handleDeepLink(event);
    }).onError((v) {
      debugPrint('Failed: $v');
    });
  }

  Future<String> createReferLink(String referCode) async {
    final DynamicLinkParameters dynamicLinkParameters = DynamicLinkParameters(
      uriPrefix: dynamicomain,
      link: Uri.parse('https://weserveu.page.link/refer?code=$referCode'),
      androidParameters: const AndroidParameters(
        packageName: 'com.weserveu.rent',
        minimumVersion: 1,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'REFER A FRIEND',
        description: 'Refer this app to your freind and earn reward',
        imageUrl: Uri.parse('https://moru.com.np/wp-content/uploads/2021/03/Blog_refer-Earn.jpg'),
      ),
    );

    final shortLink = await dynamicLink.buildShortLink(dynamicLinkParameters);

    return shortLink.shortUrl.toString();
  }

  Future<void> _handleDeepLink(PendingDynamicLinkData data) async {
    final Uri deepLink = data.link;
    var isRefer = deepLink.pathSegments.contains('refer');
    if (isRefer) {
      var code = deepLink.queryParameters['code'];
      if (code != null) {
        referrerCode.value = code;
        debugPrint('ReferrerCode $referrerCode');
        referrerCode.notifyListeners();
        await FirebaseDatabase.instance.ref().child('users').once().then((value) async {
          for(DataSnapshot snap in value.snapshot.children){
            UserModel usermodel2 = UserModel.formMap(snap.value as Map);
            if(usermodel2.referal_code==referrerCode){
              int i=0;
              i=usermodel2.rewardBalance!;
              i++;
              usermodel2.rewardBalance=i;
              await FirebaseDatabase.instance.ref().child('users').child(usermodel2.uid!).set(usermodel2.toMap());
            }
          }
        });
      }
    }
  }
}