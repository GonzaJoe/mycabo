import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycabo/Language/appLocalizations.dart';
import 'package:mycabo/constance/constance.dart';
import 'package:mycabo/models/appUserInfo.dart';

class MyProfile extends StatefulWidget {
  AppUserInfo riderInfo;
  MyProfile({this.riderInfo});
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 160,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of('My Account'),
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                        CircleAvatar(
                          radius: 35,
                          backgroundImage: Image.asset(
                            ConstanceData.userImage,
                          ).image
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
                MyAccountInfo(
                  headText: AppLocalizations.of('Level'),
                  subtext: AppLocalizations.of('Gold member'),
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
                MyAccountInfo(
                  headText: AppLocalizations.of('Name'),
                  subtext: AppLocalizations.of("joel Gonza"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                MyAccountInfo(
                  headText: AppLocalizations.of('Email'),
                  subtext: AppLocalizations.of('joelrgonza1@gmail.com'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                MyAccountInfo(
                  headText: AppLocalizations.of('Gender'),
                  subtext: AppLocalizations.of("Male"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                InkWell(
                  onTap: () {
                    showCupertinoModalPopup<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return _buildBottomPicker(
                          CupertinoDatePicker(
                            use24hFormat: true,
                            mode: CupertinoDatePickerMode.date,
                            initialDateTime: DateTime.now(),
                            onDateTimeChanged: (DateTime newDateTime) {},
                            maximumYear: 2021,
                            minimumYear: 1995,
                          ),
                        );
                      },
                    );
                  },
                  child: MyAccountInfo(
                    headText: AppLocalizations.of('Birthday'),
                    subtext: AppLocalizations.of('April 16, 1996'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                MyAccountInfo(
                  headText: AppLocalizations.of('Phone Number'),
                  subtext: AppLocalizations.of("+48XXXXXXXXXX"),
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: 240,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }
}

class MyAccountInfo extends StatelessWidget {
  final String headText;
  final String subtext;

  const MyAccountInfo({Key key, this.headText, this.subtext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(right: 10, left: 14, top: 8, bottom: 8),
        child: Row(
          children: <Widget>[
            Text(
              headText,
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
            ),
            Expanded(child: SizedBox()),
            Text(
              subtext,
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: Theme.of(context).disabledColor,
                  ),
            ),
            SizedBox(
              width: 2,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Theme.of(context).disabledColor,
            ),
          ],
        ),
      ),
    );
  }
}
