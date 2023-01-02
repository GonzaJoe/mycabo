import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mycabo/Language/LanguageData.dart';
import 'package:mycabo/modules/auth/loginScreen.dart';
import 'package:provider/provider.dart';
import 'Language/appLocalizations.dart';
import 'constance/constance.dart' as constance;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mycabo/constance/themes.dart';
import 'package:mycabo/modules/home/home_screen.dart';
import 'package:mycabo/modules/splash/introductionScreen.dart';
import 'package:mycabo/constance/global.dart' as globals;
import 'package:mycabo/constance/routes.dart';
import 'dataHandler/appData.dart';


User appUser = FirebaseAuth.instance.currentUser;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
DatabaseReference userRef = FirebaseDatabase.instance.reference().child('Users');
DatabaseReference centerRef = FirebaseDatabase.instance.reference().child('Central');
DatabaseReference driverRef = FirebaseDatabase.instance.reference().child('Drivers');
DatabaseReference newRequestRef = FirebaseDatabase.instance.reference().child('RideRequests');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) => runApp(new MyApp()));
}


class MyApp extends StatefulWidget {
  static changeTheme(BuildContext context) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.changeTheme();
  }

  static setCustomeLanguage(BuildContext context, String languageCode) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLanguage(languageCode);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = new UniqueKey();

  void changeTheme() {
    this.setState(() {
      globals.isLight = !globals.isLight;
    });
  }

  String locale = "en";
  setLanguage(String languageCode) {
    setState(() {
      locale = languageCode;
      constance.locale = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    constance.locale = locale;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: globals.isLight ? Brightness.dark : Brightness.light,
      statusBarBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: CoustomTheme.getThemeData().cardColor,
      systemNavigationBarDividerColor: CoustomTheme.getThemeData().disabledColor,
      systemNavigationBarIconBrightness: globals.isLight ? Brightness.dark : Brightness.light,
    ));
    _loadNextScreen();
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: Container(
        key: key,
        color: CoustomTheme.getThemeData().backgroundColor,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                CoustomTheme.getThemeData().backgroundColor,
                CoustomTheme.getThemeData().backgroundColor,
                CoustomTheme.getThemeData().backgroundColor.withOpacity(0.8),
                CoustomTheme.getThemeData().backgroundColor.withOpacity(0.7)
              ],
            ),
          ),
          child: MaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en'), // English
              const Locale('fr'), // French
              const Locale('ar'), // Arabic
            ],
            debugShowCheckedModeBanner: false,
            title: AppLocalizations.of('My Cab'),
            routes: routes,
            initialRoute: FirebaseAuth.instance.currentUser == null?Routes.INTRODUCTION:Routes.HOME,
            theme: CoustomTheme.getThemeData(),
            builder: (BuildContext context, Widget child) {
              return Directionality(
                textDirection: TextDirection.ltr,
                child: Builder(
                  builder: (BuildContext context) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaleFactor: 1.0,
                      ),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  var routes = <String, WidgetBuilder>{
    Routes.INTRODUCTION: (BuildContext context) => IntroductionScreen(),
    //Routes.HOME: (BuildContext context) => HomeScreen(),
    Routes.HOME: (BuildContext context) => LoginScreen(),
  };

  _loadNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    if (constance.allTextData == null) {
      constance.allTextData =
          AllTextData.fromJson(json.decode(await DefaultAssetBundle.of(context).loadString("assets/jsonFile/languagetext.json")));
    }
  }
}
