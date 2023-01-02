import 'dart:async';
import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mycabo/Language/appLocalizations.dart';
import 'package:mycabo/constance/themes.dart';
import 'package:mycabo/dataHandler/appData.dart';
import 'package:mycabo/main.dart';
import 'package:mycabo/models/directionDetails.dart';
import 'package:mycabo/models/nearbyOnlineDriver.dart';
import 'package:mycabo/modules/chat/chat_Screen.dart';
import 'package:mycabo/constance/global.dart' as globals;
import 'package:mycabo/modules/home/cancellation.dart';
import 'package:provider/provider.dart';

class RidingInfoView extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onLooping;

  const RidingInfoView({Key key, this.onBack,this.onLooping}) : super(key: key);

  @override
  _RidingInfoViewState createState() => _RidingInfoViewState();
}

class _RidingInfoViewState extends State<RidingInfoView> {
  String rideFare = "0.0";
  String requestCode;
  String rideRequestKey;
  NearbyOnlineDriver selectedDriver;
  DirectionDetails infoOnRiding;
  String currentDriverAction;
  String rideStatus = "Pick Up Address Estimations";
  bool isFareLoaded = false;
  bool isNewMsg = false;
  bool isMsgNewMsgListenerOn = false;
  bool isDriverArrived = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Future.delayed(Duration.zero,() async {
    //   await getRideFare();
    // });
  }

  @override
  Widget build(BuildContext context) {
    rideRequestKey = Provider.of<AppData>(context,listen: true).currentRideRequestKey;
    infoOnRiding = Provider.of<AppData>(context,listen: true).infoOnRiding;
    currentDriverAction = Provider.of<AppData>(context,listen: true).currentDriverAction;
    selectedDriver = Provider.of<AppData>(context,listen: true).selectedNearbyDriver;
    if(isMsgNewMsgListenerOn == false){
      isMsgNewMsgListenerOn == true;
    }
    return Stack(
      children: <Widget>[
        Positioned(
          top: 70,
          right: 10,
          child: InkWell(
            onTap: (){
              widget.onLooping();
            },
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.grey,blurRadius: 2.5)]
              ),
              child: Image.asset(
                "assets/images/loop.png",
                height: 40,
                width: 40,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Expanded(
                child: SizedBox(),
              ),
              confirmDriverBox(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget confirmDriverBox(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Container(
        height: 230,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            new BoxShadow(
              color: globals.isLight ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
              blurRadius: 4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: <Widget>[
              Container(
                color: Theme.of(context).dividerColor.withOpacity(0.03),
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 40,
                      decoration:  BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(selectedDriver.url),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                              width: 200,
                              child: Text(
                                AppLocalizations.of(selectedDriver.name),
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.subtitle1.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).textTheme.headline6.color,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Container(
                              height: 15,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    selectedDriver.rating.toStringAsFixed(1),
                                    style: Theme.of(context).textTheme.button.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).dividerColor.withOpacity(0.4),
                                    ),
                                  ),

                                  SizedBox(
                                    width: 2,
                                  ),

                                  Icon(
                                    Icons.star,
                                    size: 17,
                                    color: Colors.yellow[800],
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              width: 10,
                            ),

                            Text(
                              //AppLocalizations.of(nearbyOnlineDriver.vehicleBrand+" - "+nearbyOnlineDriver.vehicleModel),
                              AppLocalizations.of(selectedDriver.vehicleBrand+" - "+selectedDriver.vehicleModel),
                              style: Theme.of(context).textTheme.caption.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.headline6.color,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Container(
                      width: 85,
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(rideRequestKey: rideRequestKey,),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              backgroundColor: HexColor("#4353FB"),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Icon(
                                      FontAwesomeIcons.facebookMessenger,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  isNewMsg?Positioned(
                                    bottom: 0,
                                    right: 3.5,
                                    child: CircleAvatar(
                                        radius: 5,
                                        backgroundColor: Theme.of(context).primaryColor
                                    ),
                                  ): Container()
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          InkWell(
                            onTap: () async {
                              String number = selectedDriver.phone; //set the number here
                              await FlutterPhoneDirectCaller.callNumber(number);
                            },
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Center(
                                child: Icon(
                                  FontAwesomeIcons.phoneAlt,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                height: 0.5,
                color: Theme.of(context).dividerColor,
              ),
              Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.car,
                        size: 24,
                      ),
                      SizedBox(width: 15,),

                      DefaultTextStyle(
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headline6.color,
                        ),
                        child: AnimatedTextKit(
                          isRepeatingAnimation: true,
                          totalRepeatCount: 200,
                          animatedTexts: [
                            //WavyAnimatedText(AppLocalizations.of('Driver is Coming, Estimations')),
                            WavyAnimatedText(AppLocalizations.of(rideStatus)),
                          ],
                          onTap: () {
                            print("Tap Event");
                          },
                        ),
                      ),

                      // Text(
                      //   AppLocalizations.of('Driver is Coming, Estimations'),
                      //   style: Theme.of(context).textTheme.subtitle2.copyWith(
                      //         fontWeight: FontWeight.bold,
                      //         color: Theme.of(context).textTheme.headline6.color,
                      //       ),
                      // ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 14, left: 53, top: 5, bottom: 5),
                child: Column(
                  children: <Widget>[

                    SizedBox(
                      width: 8,
                    ),
                    SizedBox(
                      width: 32,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 65,
                          child: Text(
                            AppLocalizations.of('DISTANCE'),
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).dividerColor.withOpacity(0.4),
                                ),
                          ),
                        ),

                        SizedBox(
                          width: 10,
                        ),

                        Text(
                          AppLocalizations.of(infoOnRiding != null?infoOnRiding.distanceText:"0 m"),
                          style: Theme.of(context).textTheme.caption.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.headline6.color,
                              ),
                        )
                      ],
                    ),

                    SizedBox(height: 5,),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 65,
                          child: Text(
                            AppLocalizations.of('PRICE'),
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).dividerColor.withOpacity(0.4),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppLocalizations.of("Tsh. "+rideFare.toString()+"/="),
                          style: Theme.of(context).textTheme.caption.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.headline6.color,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              isDriverArrived ?Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(24.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Theme.of(context).dividerColor,
                        blurRadius: 8,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(24.0)),
                      highlightColor: Colors.transparent,
                      onTap: () async {

                      },
                      child: Center(
                        child: Text(
                          AppLocalizations.of('Confirm Driver Arrival'),
                          style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              :Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(24.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Theme.of(context).dividerColor,
                        blurRadius: 8,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(24.0)),
                      highlightColor: Colors.transparent,
                      onTap: () {
                        widget.onBack();
                        //selectCancelReason(rideRequestKey,selectedDriver.key);
                      },
                      child: Center(
                        child: Text(
                          AppLocalizations.of('Cancel'),
                          style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
