import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/user_model.dart';

enum AuthStatus {
  authenticated,
  unAuthenticated,
  unAuthenticating,
  otpSent,
  otpError,
  authenticating,
  autoOtp,
  unInitialized,
}

class AuthProvider extends ChangeNotifier {
  var _info = '';

  BuildContext context;

  AuthProvider(this.context);

  final Map<int, TextEditingController> _userOtp = {
    0: TextEditingController(),
    1: TextEditingController(),
    2: TextEditingController(),
    3: TextEditingController(),
    4: TextEditingController(),
    5: TextEditingController(),
  };

  Map<int, TextEditingController> get userOtp => _userOtp;
  String? _verificationId;
  int? _resendToken;

  User? get user {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return firebaseAuth.currentUser;
  }

  AuthStatus status = AuthStatus.unInitialized;

  UserModel userModel = UserModel();

  String get info => _info;

  /*
      Check whether user is authenticated or not
   */
  AppLocalizations? appLocalization;

  initAuthProvider(context) async {
    reset();
    appLocalization = AppLocalizations.of(context);
    if (user == null) {
      status = AuthStatus.unAuthenticated;
    } else {
      status = AuthStatus.authenticated;
    }
    notifyListeners();
  }

  ///sign in otp will be requested

  String? studentRefPath;

  signIn(Map<String, dynamic> data, BuildContext context) async {
    reset();
    status = AuthStatus.authenticating;
    notifyListeners();
    userModel.mobile = "${data['country']} ${data['mobile']}";
    status = AuthStatus.otpSent;
    sendOtp();
  }

  Timer? _timer;
  int _seconds = 60;

  set seconds(int value) {
    _seconds = value;
    notifyListeners();
  }

  int get seconds => _seconds;

  void setTimer() {
    var sec = const Duration(seconds: 1);
    _timer = Timer.periodic(sec, (s) {
      if (_seconds <= 0) {
        seconds = -1;
        _timer!.cancel();
      } else if (_seconds > 0) {
        _seconds--;
        seconds = _seconds;
      }
    });
  }

  resend() {
    status = AuthStatus.autoOtp;
    sendOtp();
  }

  ///otp submitted by user will be verified
  verifyOtp(String otp) async {
    print(status.toString());
    if (status == AuthStatus.autoOtp) {
      _info = appLocalization!.authenticated;
      status = AuthStatus.authenticated;
      _timer!.cancel();
      notifyListeners();
      return;
    }
    status = AuthStatus.authenticating;
    notifyListeners();

    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final res= await auth.signInWithCredential(PhoneAuthProvider.credential(
          verificationId: _verificationId ?? '', smsCode: otp));
      print(res.user);
      print(res.user!.uid);
      _info = appLocalization!.authenticated;
      status = AuthStatus.authenticated;
      _timer!.cancel();
      notifyListeners();
    } catch (e) {
      e as FirebaseAuthException;
      _info = appLocalization!.invalid_otp_or_mobile_number;
      status = AuthStatus.otpSent;
      _seconds = 0;
      notifyListeners();
    }
  }

  /// logout current session
  logout() async {
    FirebaseAuth.instance.signOut();
    _info = '';
    status = AuthStatus.unAuthenticated;
    notifyListeners();
  }

  void reset() {
    status = AuthStatus.unAuthenticated;
    _info = "";
    _verificationId = null;
    _resendToken = null;
    notifyListeners();
  }

  sendOtp() {
    _seconds = 60;
    try {
      if (_timer != null && _timer!.isActive) {
        _timer!.cancel();
      }
    } catch (e) {
      print(e);
    }

    FirebaseAuth auth = FirebaseAuth.instance;
    auth.verifyPhoneNumber(
        phoneNumber: userModel.mobile!,
        forceResendingToken: _resendToken,
        timeout: Duration(seconds: _seconds),
        verificationCompleted: (credential) async {
          ///for android automatic otp detection
          final code = credential.smsCode;
          if (code != null) {
            final list = code.split('');
            for (int i = 0; i < list.length; i++) {
              _userOtp[i]!.text = list[i];
            }
            await auth.signInWithCredential(credential);
            status = AuthStatus.autoOtp;
            notifyListeners();
          }
        },
        verificationFailed: (exception) {
          if (status == AuthStatus.otpSent || status == AuthStatus.autoOtp) {
            status = AuthStatus.unAuthenticated;
            _info = exception.message ?? '';
            notifyListeners();
          }
        },
        codeSent: (verificationId, forceResendingToken) {
          if (status == AuthStatus.otpSent || status == AuthStatus.autoOtp) {
            _info =
            "${appLocalization!.otp_sent_successfully_to} ${userModel.mobile}";
            _verificationId = verificationId;
            _resendToken = forceResendingToken;
            notifyListeners();
          }
        },
        codeAutoRetrievalTimeout: (verificationId) {
          if (status == AuthStatus.otpSent || status == AuthStatus.autoOtp) {
            _info = "Time Out";
            _seconds = -1;
            _verificationId = verificationId;
            notifyListeners();
          }
        });
    setTimer();
  }
}
