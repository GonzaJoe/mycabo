
class NearbyOnlineDriver{
  String key;
  String url;
  String name;
  String phone;
  String token;
  String gender;
  double rating;
  double latitude;
  double longitude;
  int totalReqServed;
  String vehicleModel;
  String vehicleSeats;
  String vehicleBrand;
  String vehicleColour;
  String vehiclePlateNo;
  String vehicleType;
  int bookingNo;

  NearbyOnlineDriver({
    this.key,
    this.longitude,
    this.token,
    this.latitude,
    this.name,
    this.phone,
    this.vehicleBrand,
    this.vehicleModel,
    this.vehiclePlateNo,
    this.vehicleColour,
    this.vehicleSeats,
    this.url,
    this.gender,
    this.rating,
    this.vehicleType,
    this.bookingNo,
    this.totalReqServed,
  });
}