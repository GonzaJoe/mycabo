import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycabo/Language/appLocalizations.dart';
import 'package:mycabo/assistants/assistantMethods.dart';
import 'package:mycabo/constance/constance.dart';
import 'package:mycabo/constance/global.dart' as globals;
import 'package:mycabo/dataHandler/appData.dart';
import 'package:mycabo/dataHandler/routes.dart';
import 'package:mycabo/main.dart';
import 'package:mycabo/modules/auth/phoneAuthScreen.dart';
import 'package:mycabo/modules/wallet/webOpenerWidget.dart';
import 'package:mycabo/modules/widgets/loadingWidget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  // Country _selectedCountry = CountryPickerUtils.getCountryByIsoCode('US');
  String phoneNumber = '';
  String countryCode = "+255";
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController numberTextEditingController = TextEditingController();
  String verificationId;
  String domain;
  bool isDomainLoaded = false;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    animationController..forward();
  }

  @override
  Widget build(BuildContext context) {
    domain = Provider.of<AppData>(context,listen: false).domain;
    globals.locale = Localizations.localeOf(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            minWidth: MediaQuery.of(context).size.width),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ClipRect(
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: AnimatedBuilder(
                            animation: animationController,
                            builder: (BuildContext context, Widget child) {
                              return Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  Transform(
                                    transform: new Matrix4.translationValues(
                                      0.0,
                                      160 *(1.0 -(AlwaysStoppedAnimation(Tween(begin: 0.4,end: 1.0).animate(CurvedAnimation(parent:animationController,curve: Curves.fastOutSlowIn))).value).value) -16,
                                      0.0
                                    ),
                                    child: Image.asset(
                                      ConstanceData.buildingImageBack,
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                  ),
                                  Transform(
                                    transform: new Matrix4.translationValues(
                                        0.0,
                                        160 *
                                            (1.0 -
                                                (AlwaysStoppedAnimation(Tween(
                                                                begin: 0.8,
                                                                end: 1.0)
                                                            .animate(CurvedAnimation(
                                                                parent:
                                                                    animationController,
                                                                curve: Curves
                                                                    .fastOutSlowIn)))
                                                        .value)
                                                    .value),
                                        0.0),
                                    child: Image.asset(
                                      ConstanceData.buildingImageBack,
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: (MediaQuery.of(context).size.height / 1.85) -(MediaQuery.of(context).size.height < 600 ? 124 : 100),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          boxShadow: [BoxShadow(color:Theme.of(context).primaryColor,blurRadius: 4)],
                          borderRadius: BorderRadius.circular(16)
                        ),
                        child: Column(
                          children: <Widget>[
                            _headerUI(),
                            _mobileNoUI(),
                            _nextButtonUI(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    AppLocalizations.of('By clicking start, your agree to our'),
                    style: Theme.of(context).textTheme.subtitle2,
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>WebOpenerWidget(webUrl:domain+UrlRoutes.terms,webTitle: "Terms of Use",)));
                        },
                        child: Text(
                          AppLocalizations.of('Terms'),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor
                          ),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(' and '),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>WebOpenerWidget(webUrl:domain+UrlRoutes.privacy,webTitle: "Privacy Policy",)));
                        },
                        child: Text(
                          AppLocalizations.of('Privacy Policy'),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8 + MediaQuery.of(context).padding.bottom,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 16, top: 30, bottom: 30),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Text(
          AppLocalizations.of('Enter your mobile Number to continue'),
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15
              ),
        ),
      ),
    );
  }

  Widget _mobileNoUI(){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(38)),
          border: Border.all(color: Theme.of(context).dividerColor, width: 0.6),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 100,
              height: 60,
              padding: EdgeInsets.only(left: 20),
              child: CountryCodePicker(
                onChanged: (e) {
                  print(e.toLongString());
                  print(e.name);
                  print(e.code);
                  print(e.dialCode);
                  setState(() {
                    countryCode = e.dialCode;
                  });
                },
                initialSelection: 'Tanzania',
                showFlagMain: true,
                showFlag: true,
                favorite: ['+255','Tanzania'],
              ),
            ),
            SizedBox(width: 10,),
            Container(
              color: Theme.of(context).dividerColor,
              height: 32,
              width: 1,
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 0, right: 16),
                child: Container(
                  height: 48,
                  child: TextField(
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    controller: numberTextEditingController,
                    style: TextStyle(fontSize: 16,),
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: new InputDecoration(
                      errorText: null,
                      border: InputBorder.none,
                      hintText: AppLocalizations.of("Phone Number"),
                      hintStyle:
                          TextStyle(color: Theme.of(context).disabledColor),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nextButtonUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            highlightColor: Colors.transparent,
            onTap: () {
              //verUserMobileNo();
              PhoneAuthCredential authCredential;
              Navigator.push(context,MaterialPageRoute(builder: (context) => PhoneVerification(mobileAuthCredential: authCredential)),);
            },
            child: Center(
              child: Text(
                AppLocalizations.of('Next'),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getCountryString(String str) {
    var newString = '';
    var isFirstdot = false;
    for (var i = 0; i < str.length; i++) {
      if (isFirstdot == false) {
        if (str[i] != ',') {
          newString = newString + str[i];
        } else {
          isFirstdot = true;
        }
      }
    }
    return newString;
  }

  void showLoadingDialog(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
            backgroundColor: Theme.of(context).backgroundColor,
            content: LoadingWidget(),
          );
        }
    );
  }
}
