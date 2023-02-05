import 'package:WeServeU/providers/app_providers.dart';
import 'package:WeServeU/routes.dart';
import 'package:WeServeU/screen/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DeepLinkService.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

///This is first file of application
const notificationKey = 'basic_channel_key';
@pragma('vm:entry-point')

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}
void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ),
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
void main() async {
  //Firebase requirement
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DeepLinkService.instance?.handleDynamicLinks();

  if(defaultTargetPlatform==TargetPlatform.android){
    AndroidGoogleMapsFlutter.useAndroidViewSurface=true;
  }
  //running app
  final prefs = await SharedPreferences.getInstance();
  Locale locale=Locale(prefs.getString('languagecode') ?? 'en');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp( locale: locale,));
}
class MyApp extends StatefulWidget {
  MyApp({Key? key,required this.locale}) : super(key: key);
  final Locale locale;
  @override
  _MyAppState createState() => _MyAppState(locale);
  static _MyAppState? of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>();
}
class _MyAppState extends State<MyApp> {
  Locale locale;
  @override
  void initState() {
    // TODO: implement initState

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      setupFlutterNotifications();
      showFlutterNotification(event);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
    super.initState();
  }
  void setLocale(Locale value) {
    setState(() {
      locale = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //getting all providers
      providers: getProviders(),
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        debugShowCheckedModeBanner: false,
        //getting all routes
        routes: routes(),
        title: "WeServeU",

        theme: ThemeData(
          primarySwatch: Colors.indigo,
          fontFamily: GoogleFonts.tenorSans().fontFamily,
          primaryColor: Colors.orange,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                textStyle: MaterialStateProperty.all<TextStyle>(
                    const TextStyle(fontSize: 18)),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                shape: MaterialStateProperty.all<OutlinedBorder>(

                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)))),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              textStyle:
                  MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 18)),
            ),
          ),
        ),

        // first flash screen will be started
        home: const MyAuth(),
      ),
    );
  }
  _MyAppState(this.locale);
}