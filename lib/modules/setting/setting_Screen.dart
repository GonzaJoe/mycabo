import 'package:flutter/material.dart';
import 'package:mycabo/Language/appLocalizations.dart';
import 'package:mycabo/constance/constance.dart';
import 'package:mycabo/constance/routes.dart';
import 'package:mycabo/dataHandler/appData.dart';
import 'package:mycabo/dataHandler/routes.dart';
import 'package:mycabo/models/appUserInfo.dart';
import 'package:mycabo/modules/setting/myProfile.dart';
import 'package:mycabo/constance/constance.dart' as constance;
import 'package:mycabo/modules/wallet/webOpenerWidget.dart';
import 'package:provider/provider.dart';
import '../../main.dart';

class SettingScreen extends StatefulWidget {
  AppUserInfo riderInfo;
  SettingScreen({this.riderInfo});
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String domain = "";
  @override
  Widget build(BuildContext context) {
    domain = Provider.of<AppData>(context,listen: false).domain;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 150,
                color: Theme.of(context).primaryColor,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).padding.top + 16,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 14, left: 14),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 14, left: 14, bottom: 16),
                    child: Row(
                      children: <Widget>[
                        Text(
                          AppLocalizations.of('Settings'),
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                myProfileDetail(),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                SizedBox(
                  height: 16,
                ),
                //userSettings(),
                SizedBox(
                  height: 16,
                ),
                userDocs(),
              ],
            ),
          )
        ],
      ),
    );
  }

  openShowPopupLanguage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                AppLocalizations.of('Select Language'),
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline6.color,
                      fontSize: 18,
                    ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                SizedBox(
                  height: 8,
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    selectLanguage('en');
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of('English'),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                SizedBox(
                  height: 8,
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    selectLanguage('fr');
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of('French'),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                SizedBox(
                  height: 8,
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    selectLanguage('ar');
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of('Arabic'),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                SizedBox(
                  height: 8,
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    selectLanguage('ja');
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of('Japanese'),
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).disabledColor,
                              fontSize: 16,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  selectLanguage(String languageCode) {
    constance.locale = languageCode;
    MyApp.setCustomeLanguage(context, languageCode);
  }

  Widget userDocs() {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Security'),
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline6.color,
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>WebOpenerWidget(webUrl:domain+UrlRoutes.terms,webTitle: "Terms of Use",)));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      AppLocalizations.of('Terms of Use'),
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.headline6.color,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>WebOpenerWidget(webUrl:domain+UrlRoutes.privacy,webTitle: "Privacy Policy",)));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      AppLocalizations.of('Privacy Policy'),
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Contact us'),
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headline6.color,
                        ),
                  ),
                  Expanded(child: SizedBox()),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Container(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
          // InkWell(
          //   highlightColor: Colors.transparent,
          //   splashColor: Colors.transparent,
          //   onTap: () {},
          //   child: Padding(
          //     padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
          //     child: Row(
          //       children: <Widget>[
          //         Text(
          //           AppLocalizations.of('Logout Out'),
          //           style: Theme.of(context).textTheme.subtitle1.copyWith(
          //             fontWeight: FontWeight.bold,
          //             color: Theme.of(context).textTheme.headline6.color,
          //           ),
          //         ),
          //         Expanded(child: SizedBox()),
          //         Icon(
          //           Icons.arrow_forward_ios,
          //           size: 18,
          //           color: Theme.of(context).disabledColor,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }

  Widget myProfileDetail() {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyProfile(riderInfo:widget.riderInfo),
          ),
        );
      },
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(right: 10, left: 14, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 35,
                backgroundImage: Image.asset(
                  ConstanceData.userImage,
                ).image
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppLocalizations.of("Joel Gonza"),
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headline6.color,
                        ),
                  ),
                  // Text(
                  //   AppLocalizations.of('Gold Member'),
                  //   style: Theme.of(context).textTheme.subtitle2.copyWith(
                  //         fontWeight: FontWeight.bold,
                  //         color: Theme.of(context).dividerColor.withOpacity(0.3),
                  //       ),
                  // ),
                ],
              ),
              Expanded(child: SizedBox()),
              Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Theme.of(context).disabledColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget userSettings() {
  //   return Container(
  //     color: Theme.of(context).backgroundColor,
  //     child: Column(
  //       children: <Widget>[
  //         Container(
  //           height: 1,
  //           color: Theme.of(context).dividerColor,
  //         ),
  //         // InkWell(
  //         //   highlightColor: Colors.transparent,
  //         //   splashColor: Colors.transparent,
  //         //   onTap: () {},
  //         //   child: Padding(
  //         //     padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
  //         //     child: Row(
  //         //       children: <Widget>[
  //         //         Text(
  //         //           AppLocalizations.of('Notifications'),
  //         //           style: Theme.of(context).textTheme.subtitle1.copyWith(
  //         //                 fontWeight: FontWeight.bold,
  //         //                 color: Theme.of(context).textTheme.headline6.color,
  //         //               ),
  //         //         ),
  //         //         Expanded(child: SizedBox()),
  //         //         Icon(
  //         //           Icons.arrow_forward_ios,
  //         //           size: 18,
  //         //           color: Theme.of(context).disabledColor,
  //         //         ),
  //         //       ],
  //         //     ),
  //         //   ),
  //         // ),
  //         Padding(
  //           padding: const EdgeInsets.only(left: 16),
  //           child: Container(
  //             height: 1,
  //             color: Theme.of(context).dividerColor,
  //           ),
  //         ),
  //         InkWell(
  //           highlightColor: Colors.transparent,
  //           splashColor: Colors.transparent,
  //           onTap: () {},
  //           child: Padding(
  //             padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
  //             child: Row(
  //               children: <Widget>[
  //                 Text(
  //                   AppLocalizations.of('Security'),
  //                   style: Theme.of(context).textTheme.subtitle1.copyWith(
  //                         fontWeight: FontWeight.bold,
  //                         color: Theme.of(context).textTheme.headline6.color,
  //                       ),
  //                 ),
  //                 Expanded(child: SizedBox()),
  //                 Icon(
  //                   Icons.arrow_forward_ios,
  //                   size: 18,
  //                   color: Theme.of(context).disabledColor,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.only(left: 16),
  //           child: Container(
  //             height: 1,
  //             color: Theme.of(context).dividerColor,
  //           ),
  //         ),
  //         InkWell(
  //           onTap: () {
  //             openShowPopupLanguage();
  //           },
  //           child: Padding(
  //             padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
  //             child: Row(
  //               children: <Widget>[
  //                 Text(
  //                   AppLocalizations.of('Language'),
  //                   style: Theme.of(context).textTheme.subtitle1.copyWith(
  //                         fontWeight: FontWeight.bold,
  //                         color: Theme.of(context).textTheme.headline6.color,
  //                       ),
  //                 ),
  //                 Expanded(child: SizedBox()),
  //                 Icon(
  //                   Icons.arrow_forward_ios,
  //                   size: 18,
  //                   color: Theme.of(context).disabledColor,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.only(left: 16),
  //           child: Container(
  //             height: 1,
  //             color: Theme.of(context).dividerColor,
  //           ),
  //         ),
  //         InkWell(
  //           onTap: () {
  //             openShowPopup();
  //           },
  //           child: Padding(
  //             padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
  //             child: Row(
  //               children: <Widget>[
  //                 Text(
  //                   AppLocalizations.of('Theme Mode'),
  //                   style: Theme.of(context).textTheme.subtitle1.copyWith(
  //                         fontWeight: FontWeight.bold,
  //                         color: Theme.of(context).textTheme.headline6.color,
  //                       ),
  //                 ),
  //                 Expanded(child: SizedBox()),
  //                 Icon(
  //                   Icons.arrow_forward_ios,
  //                   size: 18,
  //                   color: Theme.of(context).disabledColor,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         Container(
  //           height: 1,
  //           color: Theme.of(context).dividerColor,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  openShowPopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text(
                AppLocalizations.of('Select theme mode'),
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline6.color,
                      fontSize: 18,
                    ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        changeColor(light);
                      },
                      child: CircleAvatar(
                        radius: 34,
                        backgroundColor: Theme.of(context).textTheme.headline6.color,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 32,
                          child: Text(
                            AppLocalizations.of('Light'),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        changeColor(dark);
                      },
                      child: CircleAvatar(
                        radius: 34,
                        backgroundColor: Theme.of(context).textTheme.headline6.color,
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 32,
                          child: Text(
                            AppLocalizations.of('Dark'),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  int light = 1;
  int dark = 2;

  changeColor(int color) {
    if (color == light) {
      MyApp.changeTheme(context);
    } else {
      MyApp.changeTheme(context);
    }
  }
}
