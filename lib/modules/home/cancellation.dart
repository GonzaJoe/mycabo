import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mycabo/Language/appLocalizations.dart';
import 'package:mycabo/assistants/assistantMethods.dart';
import 'package:mycabo/main.dart';

class CancellationPage extends StatefulWidget {
  String reqKey;
  String driverKey;
  CancellationPage({this.reqKey,this.driverKey});

  @override
  State<CancellationPage> createState() => _CancellationPageState();
}

class _CancellationPageState extends State<CancellationPage> {
  int tappedIndex = 0;
  bool isOtherTapped = false;
  bool thereIsReason = false;
  Map cancelReasonMap;
  List<Map> reasonsList = [];
  TextEditingController otherReasonController = TextEditingController();
  
  

  @override
  void initState() {
    super.initState();
    getCancelReasons();
  }

  @override
  Widget build(BuildContext context) {
    var formHeight = 100.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            Map onCancelDoneMap = {"thereIsReason": false,};
            String outputJson = json.encode(onCancelDoneMap);
            Navigator.pop(context,outputJson);
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of("Cancellation reason"),
          style: Theme.of(context).textTheme.subtitle1.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.headline6.color,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1.0),
                        itemCount: reasonsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          String reasonDisc = reasonsList.elementAt(index)['reason'];
                          return ListTile(
                            onTap: () {
                              setState(() {
                                tappedIndex = index;
                                cancelReasonMap = reasonsList.elementAt(index);
                              });
                              if (reasonDisc == 'Other') {
                                isOtherTapped = true;
                              }
                              else{
                                isOtherTapped = false;
                              }
                            },
                            trailing: tappedIndex == index
                                ? Icon(Icons.circle_rounded, color: Colors.blue)
                                : Icon(Icons.circle_outlined),
                            title: Text(
                              AppLocalizations.of(reasonDisc),
                              style: Theme.of(context).textTheme.caption.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.headline6.color,
                              ),
                            ),
                          );
                        }),
                    SizedBox(height: 3),
                    Divider(thickness: 10, color: Colors.grey[200]),
                    SizedBox(height: 3),
                    isOtherTapped?SizedBox(
                        height: formHeight,
                        child: TextField(
                          maxLines: formHeight ~/ 20, // <--- maxLines
                          controller: otherReasonController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueAccent, width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey, width: 2.0),
                            ),
                            filled: true,
                            hintText: 'Enter your reasons',
                            fillColor: Colors.white,
                          ),
                        ),
                      )
                    :Container(),
                  ],
                ),
              ),
            ),
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
                    saveRideCancellation();
                  },
                  child: Center(
                    child: Text(
                      AppLocalizations.of('Done'),
                      style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  
  void getCancelReasons(){
    centerRef.child("riderCancelReasons").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.exists){
        Map riderCancelReasons = dataSnapshot.value;
        riderCancelReasons.forEach((key, value) {
          Map riderCancelReason = {"id":key,"reason":value};
          setState(() {
            reasonsList.add(riderCancelReason);
          });
        });
      }
    });
  }

  Future<void> saveRideCancellation() async {
    if(isOtherTapped){
      if(otherReasonController.text.isNotEmpty){
        Map otherDisc = {"otherReasonDisc":otherReasonController.text,};
        setState(() {
          cancelReasonMap.addAll(otherDisc);
        });
      }
      else {
        AssistanceMethod.displayToastMsg("Write your reason", context);
        return;
      }
    }
    DataSnapshot statusOnCancelSnap = await newRequestRef.child(widget.reqKey).child("status").get();
    Map cancelMoreInfoMap = {"user":"Rider","statusOnCancel":statusOnCancelSnap.value};
    cancelReasonMap.addAll(cancelMoreInfoMap);
    User riderId = FirebaseAuth.instance.currentUser;
    newRequestRef.child(widget.reqKey).child("status").set("Cancelled");
    newRequestRef.child(widget.reqKey).child("cancelReason").set(cancelReasonMap);
    userRef.child(riderId.uid).child("NewRequests").child(widget.reqKey).set("Cancelled");
    driverRef.child(widget.driverKey).child("NewRequests").child(widget.reqKey).set("Cancelled");
    userRef.child(riderId.uid).child("cancelReasonStat").child(cancelReasonMap["id"]).once().then((DataSnapshot dataSnapshot){
      print(dataSnapshot.exists);
      if(dataSnapshot.exists){
        int currentStat = dataSnapshot.value;
        currentStat = currentStat + 1;
        userRef.child(riderId.uid).child("cancelReasonStat").child(cancelReasonMap["id"]).set(currentStat);
      }
      else{
        int currentStat = 1;
        userRef.child(riderId.uid).child("cancelReasonStat").child(cancelReasonMap["id"]).set(currentStat);
      }
    });
    Map onCancelDoneMap = {"thereIsReason": true,"reasonId":cancelReasonMap["id"],"reqKey": widget.reqKey,"user":"Rider","userId":riderId.uid};
    String outputJson = json.encode(onCancelDoneMap);
    Navigator.pop(context,outputJson);
  }
}
