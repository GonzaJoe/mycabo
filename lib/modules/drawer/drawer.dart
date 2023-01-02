import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mycabo/Language/appLocalizations.dart';
import 'package:mycabo/constance/constance.dart';
import 'package:mycabo/constance/routes.dart';
import 'package:mycabo/models/appUserInfo.dart';
import 'package:mycabo/modules/history/history_Screen.dart';
import 'package:mycabo/modules/inviteFriends/inviteFriends_Screen.dart';
import 'package:mycabo/modules/notification/notification_Screen.dart';
import 'package:mycabo/modules/setting/setting_Screen.dart';
import 'package:mycabo/modules/wallet/myWallet.dart';

class AppDrawer extends StatefulWidget {
  final String selectItemName;
  final AppUserInfo riderInfo;

  const AppDrawer({Key key, this.selectItemName,this.riderInfo}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.centerStart,
            children: <Widget>[
              Container(
                color: Theme.of(context).primaryColor,
                height: 200,
              ),
              SizedBox(
                height: 200,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: -150,
                      right: -10,
                      top: -800,
                      bottom: 80,
                      child: SizedBox(
                        height: 800,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(500),
                          ),
                          margin: EdgeInsets.all(0),
                          color: Colors.black.withOpacity(0.06),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -200,
                      right: 110,
                      top: -50,
                      bottom: -5,
                      child: SizedBox(
                        height: 400,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(500),
                          ),
                          margin: EdgeInsets.all(0),
                          color: Colors.black.withOpacity(0.06),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Container(
                        color: Theme.of(context).cardColor,
                        padding: EdgeInsets.all(2),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: (widget.riderInfo == null)?Image.asset(
                            ConstanceData.userImage,
                          ).image
                          :Image.network(
                            widget.riderInfo.dpURL,
                          ).image,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      //AppLocalizations.of(widget.riderInfo.name),
                      "Joel Gonza",
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).backgroundColor,
                          ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  //widget.riderInfo.rating.toStringAsFixed(1),
                                  "4.5",
                                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 1.3,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 22,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Ratings",
                                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.headline6.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 26,
                    ),
                    Row(
                      children: <Widget>[
                        widget.selectItemName == 'Home' ? selectedData() : SizedBox(),
                        Icon(
                          Icons.home,
                          size: 28,
                          color: widget.selectItemName == 'Home' ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withOpacity(0.2),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          AppLocalizations.of('Home'),
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.headline6.color,
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: 32,
                    // ),
                    // InkWell(
                    //   highlightColor: Colors.transparent,
                    //   splashColor: Colors.transparent,
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => MyWallet(),
                    //       ),
                    //     );
                    //   },
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 4),
                    //     child: Row(
                    //       children: <Widget>[
                    //         widget.selectItemName == 'MyWallet' ? selectedData() : SizedBox(),
                    //         Icon(
                    //           FontAwesomeIcons.wallet,
                    //           size: 20,
                    //           color: widget.selectItemName == 'MyWallet'
                    //               ? Theme.of(context).primaryColor
                    //               : Theme.of(context).disabledColor.withOpacity(0.2),
                    //         ),
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         Text(
                    //           AppLocalizations.of('My Wallet'),
                    //           style: Theme.of(context).textTheme.subtitle2.copyWith(
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Theme.of(context).textTheme.headline6.color,
                    //               ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 32,
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoryScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Row(
                          children: <Widget>[
                            widget.selectItemName == 'History' ? selectedData() : SizedBox(),
                            Icon(
                              FontAwesomeIcons.history,
                              size: 20,
                              color: widget.selectItemName == 'History'
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).disabledColor.withOpacity(0.2),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppLocalizations.of('History'),
                              style: Theme.of(context).textTheme.subtitle2.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.headline6.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 32,
                    // ),
                    // InkWell(
                    //   highlightColor: Colors.transparent,
                    //   splashColor: Colors.transparent,
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => NotificationScreen(),
                    //       ),
                    //     );
                    //   },
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 4),
                    //     child: Row(
                    //       children: <Widget>[
                    //         widget.selectItemName == 'Notification' ? selectedData() : SizedBox(),
                    //         Icon(
                    //           FontAwesomeIcons.solidBell,
                    //           size: 20,
                    //           color: widget.selectItemName == 'Notification'
                    //               ? Theme.of(context).primaryColor
                    //               : Theme.of(context).disabledColor.withOpacity(0.2),
                    //         ),
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         Text(
                    //           AppLocalizations.of('Notification'),
                    //           style: Theme.of(context).textTheme.subtitle2.copyWith(
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Theme.of(context).textTheme.headline6.color,
                    //               ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 32,
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InviteFriendsScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Row(
                          children: <Widget>[
                            widget.selectItemName == 'Invite' ? selectedData() : SizedBox(),
                            Icon(
                              FontAwesomeIcons.gifts,
                              size: 18,
                              color: widget.selectItemName == 'Invite'
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).disabledColor.withOpacity(0.2),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppLocalizations.of('Invite Friends'),
                              style: Theme.of(context).textTheme.subtitle2.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.headline6.color,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingScreen(riderInfo:widget.riderInfo),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Row(
                          children: <Widget>[
                            widget.selectItemName == 'Setting' ? selectedData() : SizedBox(),
                            Icon(
                              FontAwesomeIcons.cog,
                              size: 20,
                              color: widget.selectItemName == 'Setting'
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).disabledColor.withOpacity(0.2),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppLocalizations.of('Setting'),
                              style: Theme.of(context).textTheme.subtitle2.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.headline6.color,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        //Navigator.pushNamedAndRemoveUntil(context, Routes.INTRODUCTION, (Route<dynamic> route) => false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.signOutAlt,
                              size: 20,
                              color: Theme.of(context).disabledColor.withOpacity(0.2),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppLocalizations.of('About us'),
                              style: Theme.of(context).textTheme.subtitle2.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.headline6.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget selectedData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 28,
          width: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
