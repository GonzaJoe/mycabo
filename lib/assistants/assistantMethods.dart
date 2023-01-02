import 'dart:convert';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mycabo/assistants/requestAssistants.dart';
import 'package:mycabo/constance/constance.dart';
import 'package:mycabo/constance/global.dart';
import 'package:mycabo/dataHandler/appData.dart';
import 'package:mycabo/main.dart';
import 'package:mycabo/models/address.dart';
import 'package:mycabo/models/appUserInfo.dart';
import 'package:mycabo/models/directionDetails.dart';
import 'package:mycabo/models/nearbyOnlineDriver.dart';
import 'package:mycabo/models/newRideRequest.dart';
import 'package:mycabo/models/vehicleType.dart';
import 'package:provider/provider.dart';

class AssistanceMethod{

  static Future<String> searchCoordinateAddress(Position position,context)async{

  }

  static Future<NewRideRequest> getRequestDetails(String reqKey) async {

  }

  static Future<DirectionDetails> obtainPlaceDirectionDetails(LatLng initialPosition,LatLng finalPosition) async {

  }

  static Future<DirectionDetails> obtainPlaceDirectionDetailsWalking(LatLng initialPosition,LatLng finalPosition) async {

  }

  static void getVehicleTypesList(context){

  }

  static double createRandomNumber(int num){
    var random = Random();
    int radNumber = random.nextInt(num);
    return radNumber.toDouble();
  }

  static void displayToastMsg(String msg, context){
    Fluttertoast.showToast(msg: msg);
  }

  static sendNotification2Driver(String token, context, String ride_request_id)async{
    var destination = Provider.of<AppData>(context,listen: false).dropOffLocation;
    Map<String,String> headerMap ={
      "Content-Type": "application/json",
      "Authorization": "Bearer $serverToken",
    };
    Map notificationMap = {
      "title":"New Ride Request",
      "body":"DropOff Address, ${destination.placeName}",
    };

    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "ride_request_id": ride_request_id,
    };

    Map sendNotificationMap = {
      "to": token,
      "notification": notificationMap,
      "data": dataMap,
      "priority": "high",
    };


    var res = await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerMap,
      body: jsonEncode(sendNotificationMap),
    );
    print("notification Send Status ::");
    print(res.statusCode);
  }
}