import 'package:mycabo/models/nearbyOnlineDriver.dart';

class GeoFireAssistants{
  static List<NearbyOnlineDriver> nearByOnlineDriversList = [];
  static void removeOnlineDriverFromList(String key){
    int index = nearByOnlineDriversList.indexWhere((element) => element.key == key);
    if(index != 0 || index != null){
      nearByOnlineDriversList.removeAt(index);
    }
  }
  static void updateOnlineDriverPositionOnMoving(NearbyOnlineDriver drivers){
    int index = nearByOnlineDriversList.indexWhere((element) => element.key == drivers.key);
    if(index != 0 || index != null){
      print(nearByOnlineDriversList);
      nearByOnlineDriversList[index].longitude = drivers.longitude;
      nearByOnlineDriversList[index].latitude = drivers.latitude;
    }
  }
}