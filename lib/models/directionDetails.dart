import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionDetails{
  double distanceValue;
  double durationValue;
  String distanceText;
  String durationText;
  String encodedPoints;
  LatLng startLatlng;
  LatLng endLatlng;
  DirectionDetails({
    this.distanceValue,
    this.durationValue,
    this.distanceText,
    this.durationText,
    this.encodedPoints,
    this.startLatlng,
    this.endLatlng,
  });


  DirectionDetails.fromMap(Map res){
    if(res != null){
      distanceValue = 1.0*res["distanceValue"];
      durationValue = 1.0*res["durationValue"];
      distanceText = res["distanceText"];
      durationText = res["durationText"];
      encodedPoints = res["encodedPoints"];
    }
  }

  // Map<String, Object> toMap() {
  //   return {
  //     'distanceValue':distanceValue,
  //     'durationValue': durationValue,
  //     'distanceText': distanceText,
  //     'durationText': durationText,
  //     'encodedPoints': encodedPoints,
  //   };
  // }
}
