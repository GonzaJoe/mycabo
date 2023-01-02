import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mycabo/Language/appLocalizations.dart';
import 'package:mycabo/constance/constance.dart';
import 'package:mycabo/dataHandler/appData.dart';
import 'package:mycabo/main.dart';
import 'package:mycabo/models/nearbyOnlineDriver.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  String rideRequestKey;
  ChatScreen({this.rideRequestKey});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  NearbyOnlineDriver selectedDriver;
  List<Map> msgMapList = [];
  TextEditingController msgFieldController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    queryMsgs();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    queryMsgs().pause();
    queryMsgs().cancel();
  }

  @override
  Widget build(BuildContext context) {
    selectedDriver = Provider.of<AppData>(context,listen: false).selectedNearbyDriver;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 110,
                  color: Theme.of(context).primaryColor,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 16,
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
                            AppLocalizations.of(selectedDriver.name),
                            style: Theme.of(context).textTheme.headline5.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            decoration:  BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(selectedDriver.url),
                                fit: BoxFit.fill,
                              ),
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: msgMapList.length,
                  itemBuilder: (context,index){
                    String sender = msgMapList[index]["Sender"];
                    String msg = msgMapList[index]["MSG"];
                    String time = msgMapList[index]["Time"];
                    String status = msgMapList[index]["Status"];
                    return sender == "Rider"? messageByMeWidget(msg,time,status): messageByDriverWidget(msg,time);
                  }
                ),
              ),
            ),
            Container(
              height: 55,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Container(
                height: 40,
                padding: EdgeInsets.only(right: 14, left: 14),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  ),
                  color: Theme.of(context).backgroundColor,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: msgFieldController,
                        cursorColor: Theme.of(context).primaryColor,
                        autofocus: false,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Theme.of(context).textTheme.headline6.color,
                              fontWeight: FontWeight.bold,
                            ),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of('Type a message...'),
                          hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Theme.of(context).dividerColor,
                                fontWeight: FontWeight.bold,
                              ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    InkWell(
                      onTap: (){
                        if(msgFieldController.text != null){
                          msgFieldController.text = "";
                        }
                      },
                      child: Icon(
                        Icons.send,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageByMeWidget(String msg, String dtime, String status){
    DateTime datetime = DateTime.parse(dtime);
    String minutes = datetime.minute.toString().padLeft(2,'0');
    String hours = datetime.hour.toString().padLeft(2,'0');
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(msg+" - "+hours+" : "+minutes),
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13
                  ),
                ),
              ),
            ),
            SizedBox(width: 4,),
            status != "Sent"
                ?Icon(
                Icons.done_all_sharp,
                color: Theme.of(context).primaryColor,
                size: 17,
                )
                :Icon(Icons.done_all_sharp,size: 17,)
          ],
        ),
        SizedBox(height: 12,)
      ],
    );
  }

  Widget messageByDriverWidget(String msg,String dtime){
    DateTime datetime = DateTime.parse(dtime);
    String minutes = datetime.minute.toString().padLeft(2,'0');
    String hours = datetime.hour.toString().padLeft(2,'0');
    return Column(
      children: [
        Row(
          children: <Widget>[
            Flexible(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(msg+" - "+hours+" : "+minutes),
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 12,)
      ],
    );
  }

  StreamSubscription<Event> queryMsgs(){
    return newRequestRef.child(widget.rideRequestKey).child("massages").onValue.listen((event){
      if(event.snapshot.exists){
        Map msgs = event.snapshot.value as Map<dynamic, dynamic>;
        if(mounted){
          setState(() {
            msgMapList = [];
            msgs.forEach((key, value) {
              newRequestRef.child(widget.rideRequestKey).child("massages").child(key).set(value);
              Map msg = value as Map<dynamic, dynamic>;
              msgMapList.add(msg);
            });
          });
        }
      }
    });
  }
}
