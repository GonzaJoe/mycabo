import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mycabo/Language/appLocalizations.dart';
import 'package:mycabo/constance/constance.dart';
import 'package:mycabo/constance/themes.dart';
import 'package:mycabo/main.dart';
import 'package:table_calendar/table_calendar.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime datetime;
  String date;
  List<Map> historyList = [
    {"pickup_address":"Kopinska", "dropoff_address":"centrum", "rideFare": 50, "status": "Completed"},
    {"pickup_address":"waweska", "dropoff_address":"lokowa", "rideFare": 65, "status": "Cancelled"},
    {"pickup_address":"Kopinska", "dropoff_address":"centrum", "rideFare": 50, "status": "Completed"},
    {"pickup_address":"waweska", "dropoff_address":"lokowa", "rideFare": 65, "status": "Cancelled"},
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    datetime = DateTime.now();
    date = DateFormat('MMM dd, yyyy').format(DateTime.now());
    //getRiderRideHistory(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3.5,
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
                      AppLocalizations.of('History'),
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    ClipRect(
                      child: BackdropFilter(
                        filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          decoration: new BoxDecoration(
                            color: Colors.grey.shade200.withOpacity(0.5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () async {
                                    DateTime dateTime = await selectDate();
                                    setState(() {
                                      date = DateFormat('MMM dd, yyyy').format(dateTime);
                                      datetime = dateTime;
                                      //getRiderRideHistory(date);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2),
                                    child: Text(
                                      AppLocalizations.of(date),
                                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  //padding: EdgeInsets.only(top: 0, right: 14, left: 14),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: historyList.length,
                    itemBuilder: (context,index){
                      return rideDetailsCard(historyList[index]);
                    }
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future selectDate(){
    DateTime _selectedDay = DateTime.now();
    DateTime _focusedDay = DateTime.now();
    return showDialog(
        context: context, builder: (context){
      return StatefulBuilder(
          builder: (context,StateSetter setState){
            return Padding(
                padding: EdgeInsets.symmetric(vertical: 100,horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      //height: 350,
                      color: Theme.of(context).primaryColor,
                      child: Material(
                        color: Theme.of(context).primaryColor,
                        child: TableCalendar(
                          firstDay: DateTime.utc(2022, 01, 01),
                          lastDay: DateTime.now(),
                          focusedDay: _focusedDay,
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(color: Colors.blue),
                            weekendStyle: TextStyle(color: Colors.blue),
                          ),
                          calendarStyle: CalendarStyle(
                            weekendTextStyle: TextStyle(color: Colors.black),
                            defaultTextStyle: TextStyle(color: Colors.black),
                            disabledTextStyle: TextStyle(color: Theme.of(context).primaryColor),
                            outsideTextStyle: TextStyle(color: Color(0xFF5A5A5A)),
                          ),
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          onDaySelected: (selectedDay, focusedDay){
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = selectedDay;
                            });
                            Navigator.pop(context,_selectedDay);
                          },
                        ),
                      ),
                    ),
                  ],
                )
            );
          }
      );
    }
    );
  }
  
  void getRiderRideHistory(String dateTxt){
    User rider = FirebaseAuth.instance.currentUser;
    userRef.child(rider.uid).child("NewRequests").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.exists)
        historyList = [];
        Map reqKeys = dataSnapshot.value;
        reqKeys.forEach((key, value) async {
          DataSnapshot reqSnap = await newRequestRef.child(key).get();
          if(reqSnap.exists){
            Map reqSnapMap = reqSnap.value;
            if(reqSnapMap != null){
              String reqDate = DateFormat('MMM dd, yyyy').format(DateTime.parse(reqSnapMap["created_at"]));
              if(reqDate == dateTxt){
                setState(() {
                  historyList.add(reqSnapMap);
                });
              }
            }
          }
        });
    });
  }

  Widget rideDetailsCard(Map rideInfo){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    ConstanceData.startPin,
                    height: 32,
                    width: 32,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    rideInfo["pickup_address"],
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: Theme.of(context).textTheme.headline6.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 22,
              ),
              child: Container(
                height: 16,
                width: 2,
                color: Theme.of(context).dividerColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    ConstanceData.endPin,
                    height: 30,
                    width: 30,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    rideInfo["dropoff_address"],
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: Theme.of(context).textTheme.headline6.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Theme.of(context).disabledColor,
                    child: Icon(
                      FontAwesomeIcons.coins,
                      color: Theme.of(context).backgroundColor,
                      size: 16,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "PLN ${rideInfo["rideFare"]}/=",
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: Theme.of(context).textTheme.headline6.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      rideInfo["status"],
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                        color: HexColor("#55E274"),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
