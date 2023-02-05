import 'package:WeServeU/screen/data_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import '../dashboards/client_dashboard.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'otp_verify_screen.dart';

enum InternetStatus { online, offline }

class MyAuth extends StatefulWidget {
  const MyAuth({Key? key}) : super(key: key);
  static const routeName = '/auth-screen';

  @override
  State<MyAuth> createState() => _MyAuthState();
}

class _MyAuthState extends State<MyAuth> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff5e7af3), //or set color with: Color(0xFF0000FF)
    ));
    return SafeArea(
      child: Scaffold(
        body: Consumer<AuthProvider>(
          builder: (ctx, provider, _) {
            return _getScreen(provider);
          },
        ),
      ),
    );
  }

  var init = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    if (!kIsWeb) {
      initInternet();
    }
    Future.delayed(const Duration(milliseconds: 500)).whenComplete(() {
      Provider.of<AuthProvider>(context, listen: false)
          .initAuthProvider(context);
    });
    super.initState();
  }

  dynamic internetSubscription;

  ///      Notify user about internet changes
  void initInternet() async {
    internetSubscription =
        Connectivity().onConnectivityChanged.listen((event) async {
          if (event == ConnectivityResult.none) {
            var online = await InternetConnectionChecker().hasConnection;
            if (!online) {
              if (internetStatus == InternetStatus.online) {
                offlineToast();
                internetStatus = InternetStatus.offline;
                try {
                  setState(() {});
                } catch (e) {
                  //print()
                }
              }
            }
          } else {
            var online = await InternetConnectionChecker().hasConnection;
            if (online) {
              if (internetStatus == InternetStatus.offline) {
                onlineToast();
                setState(() {
                  internetStatus = InternetStatus.online;
                });
              }
            }
          }
        });
  }

  Widget _getScreen(AuthProvider user) {
    /// This main part of app who will monitor login state and detect internet connection

    switch (user.status) {
      case AuthStatus.unAuthenticated:
      /// if user is not authenticated
        return const Login();

    /// once user tap on continue button in login screen
      case AuthStatus.otpSent:
      case AuthStatus.autoOtp:
        return const OtpVerifyScreen();

    /// if user is authenticated

      case AuthStatus.authenticated:
        return DataScreen();

    ///        If user authentication is started or firebase auth is not initialized
      case AuthStatus.unInitialized:
      case AuthStatus.authenticating:
      default:
        return Center(child:  Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              color:Color(0xff5e7af3)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Barizah',
                style: TextStyle(color: Colors.white, fontSize: 40,),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
        );
    }
  }

  void offlineToast() {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context).youAreOffline,
        toastLength: Toast.LENGTH_LONG);
  }

  void onlineToast() {
    Fluttertoast.showToast(
        msg: AppLocalizations.of(context).backToOnline,
        toastLength: Toast.LENGTH_LONG);
  }
}

