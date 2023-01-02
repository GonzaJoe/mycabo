import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mycabo/models/nearbyOnlineDriver.dart';

class NewRideRequest{
  LatLng riderPickUp;
  LatLng riderDropOff;
  String rideDistanceText;
  double rideDistanceValue;
  String rideTimeText;
  String rideFare;
  String discountedFare;
  String rideDiscount;
  double rideTimeValue;
  String rideStatus;
  String requestCode;
  String requestKey;
  String riderPickUpName;
  String riderDropOffName;
  String paymentMethod;
  DateTime rideDateTime;
  NearbyOnlineDriver driverInfo;

  NewRideRequest({
      this.riderPickUp,
      this.riderDropOff,
      this.riderPickUpName,
      this.riderDropOffName,
      this.rideDistanceText,
      this.rideDistanceValue,
      this.rideFare,
      this.rideDiscount,
      this.rideTimeText,
      this.rideTimeValue,
      this.requestCode,
      this.rideDateTime,
      this.rideStatus,
      this.paymentMethod,
      this.requestKey,
      this.driverInfo,
      this.discountedFare,
    }
  );
}