import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mycabo/models/address.dart';
import 'package:mycabo/models/appUserInfo.dart';
import 'package:mycabo/models/directionDetails.dart';
import 'package:mycabo/models/nearbyOnlineDriver.dart';
import 'package:mycabo/models/vehicleType.dart';

class AppData extends ChangeNotifier{
  Address pickUpLocation,dropOffLocation;
  String earnings = "0";
  String editedPickUpLocation = "";
  String domain = "";
  String otpCode = "";
  String currentRideRequestKey = "";
  AppUserInfo appUserInfo;
  PhoneAuthCredential authCredential;
  String currentDriverAction;
  DirectionDetails infoOnRiding;
  int countTrips = 0;
  int countBookedTrips = 0;
  List<String> tripHistoryKeys = [];
  List<VehicleType> vehicleTypesList = [];
  List< NearbyOnlineDriver> nearbyOnlineDriverList = [];
  NearbyOnlineDriver selectedNearbyDriver;
  //List<History> tripHistoryDataList = [];
  List<String> tripBookingKeys = [];
  //List<Booked> bookingsDataList = [];

  void updatepickUpLocation(Address pickUpAddress){
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocation(Address dropOffAddress){
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }

  void updateEarnings(String updatedEarnings){
    earnings = updatedEarnings;
    notifyListeners();
  }

  void updateTripsCounter(int tripCounter){
    countTrips = tripCounter;
    notifyListeners();
  }

  void updateBookedTripsCounter(int tripBookedCounter){
    countBookedTrips = tripBookedCounter;
    notifyListeners();
  }

  void updateTripsKeys(List<String> newKeys){
    tripHistoryKeys = newKeys;
    notifyListeners();
  }

  void updateDomain(String dbDomain){
    domain = dbDomain;
    notifyListeners();
  }

  void updateBookingKeys(List<String> newKeys){
    tripBookingKeys = newKeys;
    notifyListeners();
  }

  void updateAppUserInfo(AppUserInfo currentUser){
    appUserInfo = currentUser;
    notifyListeners();
  }

  void updatePhoneAuthCredential(PhoneAuthCredential authCredentials){
    authCredential = authCredentials;
    notifyListeners();
  }

  void updateVehicleTypesList(List<VehicleType> availableVehicleTypesList){
    vehicleTypesList = availableVehicleTypesList;
    notifyListeners();
  }

  void updateNearbyOnlineDriverList(List<NearbyOnlineDriver> onlineDriverList){
    nearbyOnlineDriverList = onlineDriverList;
    notifyListeners();
  }

  void updateCurrentRideRequestKey(String rideRequest){
    currentRideRequestKey = rideRequest;
    notifyListeners();
  }

  void updateDriverRideAction(String driverAction){
    currentDriverAction = driverAction;
    notifyListeners();
  }

  void updateInfoOnRiding(DirectionDetails directionDetails){
    infoOnRiding = directionDetails;
    notifyListeners();
  }

  void updateSelectedDriver(NearbyOnlineDriver selectedDriver){
    selectedNearbyDriver = selectedDriver;
    notifyListeners();
  }

  // void updateTripsHistoryData(List<History> historyList){
  //   tripHistoryDataList = [];
  //   tripHistoryDataList.addAll(historyList);
  //   notifyListeners();
  // }
  //
  // void updateBookingsData(List<Booked> bookingsList){
  //   bookingsDataList = [];
  //   bookingsDataList.addAll(bookingsList);
  //   notifyListeners();
  // }

  void changePickUpLocationTextInputValue(String pickUpLoc){
    //editedPickUpLocation = pickUpLoc;
    editedPickUpLocation = pickUpLoc;
    print("#################################");
    print("place Name");
    notifyListeners();
  }
}