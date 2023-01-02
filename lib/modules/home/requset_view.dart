import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mycabo/Language/appLocalizations.dart';
import 'package:mycabo/assistants/assistantMethods.dart';
import 'package:mycabo/assistants/requestAssistants.dart';
import 'package:mycabo/constance/constance.dart';
import 'package:mycabo/constance/global.dart';
import 'package:mycabo/constance/themes.dart';
import 'package:mycabo/dataHandler/appData.dart';
import 'package:mycabo/main.dart';
import 'package:mycabo/models/directionDetails.dart';
import 'package:mycabo/models/nearbyOnlineDriver.dart';
import 'package:mycabo/models/vehicleType.dart';
import 'package:mycabo/modules/chat/chat_Screen.dart';
import 'package:mycabo/modules/home/cancellation.dart';
import 'package:mycabo/modules/home/driverList.dart';
import 'package:mycabo/modules/home/promoCodeView.dart';
import 'package:mycabo/constance/global.dart' as globals;
import 'package:mycabo/modules/widgets/loadingWidget.dart';
import 'package:provider/provider.dart';

import '../../dataHandler/routes.dart';

class RequsetView extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onForward;
  final VoidCallback onLooping;
  final DirectionDetails rideDirectionDetails;
  final List faresList;

  const RequsetView({Key key,
    this.onBack,
    this.onForward,
    this.onLooping,
    this.rideDirectionDetails,
    this.faresList,
  }) : super(key: key);

  @override
  _RequsetViewState createState() => _RequsetViewState();
}

class _RequsetViewState extends State<RequsetView> {
  String rideFare = "";
  String rideTimeText = "";
  double rideTimeValue = 0;
  String reqCode = "";
  String rideState = "";
  String rideDistanceText = "";
  double rideDistanceValue = 0;
  String selectedCar = "Select Vehicle";
  bool isCarSelected = false;
  bool isDriverSelected = false;
  bool isDriverAcceptReq = false;
  List<VehicleType> vehicleTypesList =[];
  List<NearbyOnlineDriver> nearbyOnlineDriverList = [];
  NearbyOnlineDriver nearbyOnlineDriver;
  DatabaseReference rideRequestRef;
  VehicleType selectedVehicle;
  Timer timer;
  int startSec = 25;
  String currentReqId;
  int existBookingNo1 = 0;
  int existBookingNo2 = 0;
  int existBookingNo3 = 0;
  int existBookingNo4 = 0;
  bool isFareCalculated = false;
  Map fare1Map = {"rideFare":45.0,"discRideFare":50.0};
  Map fare2Map = {"rideFare":50.0,"discRideFare":55.0};
  Map fare3Map = {"rideFare":55.0,"discRideFare":60.0};
  Map fare4Map = {"rideFare":60.0,"discRideFare":65.0};
  int selectedIndex;
  bool joe = false;
  double reqFare;
  double discFare;
  List<NearbyOnlineDriver> nearbyOnlineDriverListByBookingType = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    List<Map> vehiclesList = [
      {"name":"Moto","url":"https://egypt.globalbajaj.com/-/media/Egypt/Images/Boxer/Boxer-150/Variant-Banner_1640x997.png?h=997&la=en&w=1640&hash=D15F2CF36B25B2CAA5804471EDCEF17F","bookingNo": 1,"seats": 1,"priceForFirstKm":15.0,"priceForExtraKm":3.0},
      {"name":"Bajaj","url":"https://cdn.shopify.com/s/files/1/2692/8652/products/IuXJ2Q1dTs_1024x1024.jpg?v=1643193936","bookingNo": 2,"seats": 1,"priceForFirstKm":20.0,"priceForExtraKm":5.0},
      {"name":"carX","url":"https://media.istockphoto.com/id/170110046/photo/photorealistic-illustration-of-blue-car.jpg?s=612x612&w=0&k=20&c=-hoFPF15-T07bUBJn6ccsSwGw96ZObf5JEdS4Y8Co1M=","bookingNo": 3,"seats": 1,"priceForFirstKm":25.0,"priceForExtraKm":8.0},
      {"name":"carXL","url":"https://s3-eu-west-1.amazonaws.com/localrent.images/cars/image_titles/000/024/116/original/Toyota-Noah-2011-white-R.jpg?1640627729","bookingNo": 4,"seats": 1,"priceForFirstKm":30.0,"priceForExtraKm":10.0},
    ];
    vehiclesList.forEach((element) {
      VehicleType x = VehicleType();
      x.name = element["name"];
      x.url = element["url"];
      x.bookingNo = element["bookingNo"];
      x.seats = element["seats"];
      x.priceForFirstKm = element["priceForFirstKm"];
      x.priceForExtraKm = element["priceForExtraKm"];
      vehicleTypesList.add(x);
    });
  }


  @override
  Widget build(BuildContext context) {
    //vehicleTypesList = Provider.of<AppData>(context,listen: false).vehicleTypesList;
    //nearbyOnlineDriverList = Provider.of<AppData>(context,listen: true).nearbyOnlineDriverList;
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
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 8, right: 8),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      height: AppBar().preferredSize.height,
                      width: AppBar().preferredSize.height,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          margin: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          child: InkWell(
                              onTap: () {
                                widget.onBack();
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child:Container(
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                boxShadow: [BoxShadow(
                    color:Theme.of(context).primaryColor,
                    blurRadius: 5,
                    blurStyle: BlurStyle.outer
                )]
            ),
            child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).dividerColor.withOpacity(0.03),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(FontAwesomeIcons.car,color: Theme.of(context).primaryColor),
                                  SizedBox(width: 16),
                                  Text(
                                    AppLocalizations.of("Select Vehicle"),
                                    style: Theme.of(context).textTheme.subtitle2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Theme.of(context).disabledColor,
                    ),
                    Container(
                      height: 200,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: vehicleTypesList.length,
                          itemBuilder: (BuildContext context, int index){
                            String vehicleSpesificCalc;
                            double actualFare;
                            double discountedFare;
                            double discount;
                            Color color;
                            if(selectedIndex == index){
                              color = Theme.of(context).primaryColor.withOpacity(0.12);
                            }
                            else{
                              color = Theme.of(context).scaffoldBackgroundColor;
                            }
                            if(vehicleTypesList[index].bookingNo == 1){
                              existBookingNo1 != 0?vehicleSpesificCalc = existBookingNo1.toString():vehicleSpesificCalc = "Busy";
                              actualFare = fare1Map["rideFare"];
                              discountedFare = 1.0*fare1Map["discRideFare"];
                            }
                            else if(vehicleTypesList[index].bookingNo == 2){
                              existBookingNo2 != 0?vehicleSpesificCalc = existBookingNo2.toString():vehicleSpesificCalc = "Busy";
                              actualFare = fare2Map["rideFare"];
                              discountedFare = 1.0*fare2Map["discRideFare"];
                            }
                            else if(vehicleTypesList[index].bookingNo == 3){
                              existBookingNo3 != 0?vehicleSpesificCalc = existBookingNo3.toString():vehicleSpesificCalc = "Busy";
                              actualFare = fare3Map["rideFare"];
                              discountedFare = 1.0*fare3Map["discRideFare"];
                            }
                            else{
                              existBookingNo4 != 0?vehicleSpesificCalc = existBookingNo4.toString():vehicleSpesificCalc = "Busy";
                              actualFare = fare4Map["rideFare"];
                              discountedFare = 1.0*fare4Map["discRideFare"];
                            }
                            reqFare = actualFare;
                            discFare = discountedFare;
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                              child: InkWell(
                                onTap: () async {
                                  setState(() {selectedVehicle = vehicleTypesList[index];});
                                  setState(() {selectedIndex = index;});
                                  selectedCarInfo(vehicleTypesList[index]);
                                  NearbyOnlineDriver selectedDriver = await Navigator.push(context,MaterialPageRoute(builder: (context) => DriverList(nearbyOnlineDriversList:nearbyOnlineDriverListByBookingType,vehicleType:selectedVehicle.name),),);
                                  if(selectedDriver != null){
                                    nearbyOnlineDriver = selectedDriver;
                                    Provider.of<AppData>(context,listen: false).updateSelectedDriver(selectedDriver);
                                    requestStatusDialog(context);
                                    widget.onForward();
                                  }
                                },
                                child: Container(
                                  height: 65,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      new BoxShadow(
                                        color: globals.isLight ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                                        child: Image.network(
                                          vehicleTypesList[index].url,
                                          height: 50,
                                          width: 50,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              vehicleTypesList[index].name + " ($vehicleSpesificCalc)",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 16.0),
                                              //style: Theme.of(context).textTheme.bodyText1,
                                            ),
                                            SizedBox(height: 3.0,),
                                            Text(
                                              "Seats " +vehicleTypesList[index].seats.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 12.0,color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 115,
                                        padding: EdgeInsets.only(right: 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "Tsh ${discountedFare.toStringAsFixed(1)}/=",
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context).textTheme.subtitle1.copyWith(
                                                  color: Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "Tsh ${actualFare.toStringAsFixed(1)}/=",
                                                style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                    color: Theme.of(context).disabledColor,
                                                    fontWeight: FontWeight.normal,
                                                    fontSize: 13,
                                                    decoration: TextDecoration.lineThrough
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    )
                  ],
                ),
              ],
            ),
          )
          //: confirmDriverBox(context),
        ),
      ],
    );
  }

  void showLoadingDialog(){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context){
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
          backgroundColor: Theme.of(context).backgroundColor,
          content: LoadingWidget(),
        );
      }
    );
  }

  Widget driverPic(String url){
    return Container(
      height: 40,
      width: 40,
      padding: EdgeInsets.all(3),
      decoration:  BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).primaryColor.withOpacity(0.2),
      ),
      child: CircleAvatar(
        backgroundImage: NetworkImage(url),
      ),
    );
  }


  void startTimer(){
    const oneSec = const Duration(seconds: 1);
    timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (startSec == 0) {
          setState(() {
            timer.cancel();
            cancelRide("Timeout, Choose another driver");
          });
        } else {
          print(startSec);
          if(mounted){
            setState(() {
              startSec--;
            });
          }
        }
      },
    );
  }

  void cancelRide(String reason){
    // newRequestRef.child(currentReqId).remove();
    // driverRef.child(nearbyOnlineDriver.key).child("NewRequests").child(currentReqId).remove();
    if(mounted){
      Navigator.pop(context);
      AssistanceMethod.displayToastMsg(reason, context);
    }
  }

  requestStatusDialog(BuildContext context){
    setState(() {
      startSec = 25;
      startTimer();
    });
    //bool isDriverAcceptReq = Provider.of<AppData>(context,listen: false).isDriverAcceptReq;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return AlertDialog(
          contentPadding: EdgeInsets.only(top: 12),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              isDriverAcceptReq
              ?Icon(
                Icons.check_circle,
                size: 80,
                color: Theme.of(context).primaryColor,
              )
              :Container(
                height: 80,
                child: LoadingIndicator(
                    indicatorType: Indicator.ballClipRotatePulse, /// Required, The loading type of the widget
                    colors: [Theme.of(context).primaryColor],                  /// Optional, The color collections
                    strokeWidth: 8,                               /// Optional, The stroke of the line, only applicable to widget which contains line
                    backgroundColor: Colors.white,                /// Optional, Background of the widget
                    pathBackgroundColor: Colors.black             /// Optional, the stroke backgroundColor
                ),
              ),
              Text(
                AppLocalizations.of('Waiting for driver response'),
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Theme.of(context).textTheme.subtitle1.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                color: Theme.of(context).dividerColor.withOpacity(0.03),
                padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(45),
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration:  BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(nearbyOnlineDriver.url),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 100,
                              child: Text(
                                nearbyOnlineDriver.name,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.subtitle1.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            Text(
                              " ("+nearbyOnlineDriver.gender+")",
                              style: Theme.of(context).textTheme.subtitle1.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: 12
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              nearbyOnlineDriver.rating.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).textTheme.headline6.color,
                                  fontSize: 14
                              ),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Icon(
                                Icons.star,
                                color: Colors.yellow[800],
                                size: 18
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Text(
                          AppLocalizations.of(nearbyOnlineDriver.vehicleModel +" - "+nearbyOnlineDriver.vehiclePlateNo),
                          style: Theme.of(context).textTheme.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.headline6.color,
                          ),
                        ),
                      ],
                    ),
                    //Expanded(child: SizedBox(),),
                  ],
                ),
              ),
              Divider(
                height: 0,
              ),
              Padding(
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
                        //timer.cancel();
                        //cancelRide("You have cancelled");
                        Navigator.pop(context);
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
        );
      },
    );
  }

  Future<void> selectedCarInfo(VehicleType selectedVeh) async {
    setOnlineDriverByBookingType(selectedVeh);
    setState(() {
      isCarSelected = true;
      selectedCar = selectedVeh.name;
      // rideDistanceText = widget.rideDirectionDetails.distanceText;
      // rideDistanceValue = widget.rideDirectionDetails.distanceValue;
      // rideTimeText = widget.rideDirectionDetails.durationText;
      // rideTimeValue = widget.rideDirectionDetails.durationValue;
      selectedVehicle = selectedVeh;
    });
  }

  void setOnlineDriverByBookingType(VehicleType selectedVeh){
    nearbyOnlineDriverListByBookingType = [];
    nearbyOnlineDriverList = [];
    List<Map> y = [
      {"key":"1","url":"https://www.clipartmax.com/png/middle/69-697178_male-avatar-avatar-male.png","name":"Jojo","phone":"0783207124","token":"","gender":"male","rating":2.3,"latitude":5.55,"longitude":4.00,"totalReqServed":3,"vehicleModel":"V2","vehicleSeats":"6","vehicleBrand":"Boxer","vehicleColour":"Black","vehiclePlateNo":"T 124 AHA","vehicleType":"boda","bookingNo":1},
      {"key":"2","url":"https://www.clipartmax.com/png/middle/69-697178_male-avatar-avatar-male.png","name":"Naomi","phone":"0783207124","token":"","gender":"Female","rating":2.5,"latitude":5.55,"longitude":4.00,"totalReqServed":4,"vehicleModel":"V3","vehicleSeats":"6","vehicleBrand":"Toyo","vehicleColour":"Black","vehiclePlateNo":"T 125 AHB","vehicleType":"boda","bookingNo":1},
      {"key":"3","url":"https://www.clipartmax.com/png/middle/69-697178_male-avatar-avatar-male.png","name":"Mussa","phone":"0783207124","token":"","gender":"male","rating":2.6,"latitude":5.55,"longitude":4.00,"totalReqServed":5,"vehicleModel":"baj1","vehicleSeats":"6","vehicleBrand":"Bajaji","vehicleColour":"Black","vehiclePlateNo":"T 126 AHC","vehicleType":"Bajaj","bookingNo":2},
      {"key":"4","url":"https://www.clipartmax.com/png/middle/69-697178_male-avatar-avatar-male.png","name":"Kanani","phone":"0783207124","token":"","gender":"male","rating":2.7,"latitude":5.55,"longitude":4.00,"totalReqServed":6,"vehicleModel":"baj2","vehicleSeats":"6","vehicleBrand":"Bajaji","vehicleColour":"Black","vehiclePlateNo":"T 127 AHD","vehicleType":"Bajaj","bookingNo":2},
      {"key":"5","url":"https://www.clipartmax.com/png/middle/69-697178_male-avatar-avatar-male.png","name":"Mushi","phone":"0783207124","token":"","gender":"male","rating":2.8,"latitude":5.55,"longitude":4.00,"totalReqServed":7,"vehicleModel":"carina","vehicleSeats":"6","vehicleBrand":"Toyota","vehicleColour":"Black","vehiclePlateNo":"T 128 AHE","vehicleType":"carX","bookingNo":3},
      {"key":"6","url":"https://www.clipartmax.com/png/middle/69-697178_male-avatar-avatar-male.png","name":"John","phone":"0783207124","token":"","gender":"male","rating":2.9,"latitude":5.55,"longitude":4.00,"totalReqServed":8,"vehicleModel":"carina","vehicleSeats":"6","vehicleBrand":"Toyota","vehicleColour":"Black","vehiclePlateNo":"T 129 AHF","vehicleType":"carX","bookingNo":3},
      {"key":"7","url":"https://www.clipartmax.com/png/middle/69-697178_male-avatar-avatar-male.png","name":"Michael","phone":"0783207124","token":"","gender":"male","rating":3.0,"latitude":5.55,"longitude":4.00,"totalReqServed":9,"vehicleModel":"Noah","vehicleSeats":"6","vehicleBrand":"Toyota","vehicleColour":"Black","vehiclePlateNo":"T 130 AHG","vehicleType":"carXL","bookingNo":4},
      {"key":"8","url":"https://www.clipartmax.com/png/middle/69-697178_male-avatar-avatar-male.png","name":"Salome","phone":"0783207124","token":"","gender":"Female","rating":3.1,"latitude":5.55,"longitude":4.00,"totalReqServed":10,"vehicleModel":"Alphad","vehicleSeats":"6","vehicleBrand":"Toyota","vehicleColour":"Black","vehiclePlateNo":"T 131 AHH","vehicleType":"carXL","bookingNo":4},
    ];
    y.forEach((element) {
      NearbyOnlineDriver z = NearbyOnlineDriver();
      z.key = element["key"];
      z.url = element["url"];
      z.name = element["name"];
      z.phone = element["phone"];
      z.token = element["token"];
      z.gender = element["gender"];
      z.rating = element["rating"];
      z.latitude = element["latitude"];
      z.longitude = element["longitude"];
      z.totalReqServed = element["totalReqServed"];
      z.vehicleModel = element["vehicleModel"];
      z.vehicleSeats = element["vehicleSeats"];
      z.vehicleBrand = element["vehicleBrand"];
      z.vehicleColour = element["vehicleColour"];
      z.vehiclePlateNo = element["vehiclePlateNo"];
      z.vehicleType = element["vehicleType"];
      z.bookingNo = element["bookingNo"];
      setState(() {
        nearbyOnlineDriverList.add(z);
      });
    });
    nearbyOnlineDriverList.forEach((onlineDriver){
      print(onlineDriver.bookingNo);
      print("roro");
      if(onlineDriver.bookingNo == selectedVeh.bookingNo){
        setState(() {
          nearbyOnlineDriverListByBookingType.add(onlineDriver);
          print(nearbyOnlineDriverListByBookingType);
        });
      }
    });
    print(nearbyOnlineDriverListByBookingType);
  }
}
