import 'package:maps_toolkit/maps_toolkit.dart';

class MapKitAssistant{ //calculate the heading from one point to another point(in degree clockwise from north)
  static double getMarkerRotation(sLat,sLng,dLat,dLng){
    var rot = SphericalUtil.computeHeading(LatLng(sLat, sLng), LatLng(dLat, dLng));
    return rot;
  }
}