import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mycabo/Language/LanguageData.dart';
import 'package:mycabo/Language/appLocalizations.dart';

class ConstanceData {
  static const IOS_AppId = "123456789";
  static const IOS_APP_Link = "https://apps.apple.com/app//" + IOS_AppId;
  static const LOCATION_MODE = "Location_Mode";
  static const THEME_MODE = 'theme_Mode';
  static const User_Login_Time = 'User_Login_Time';
  static const LAST_PDF_Time = 'LAST_PDF_TIME';
  static const IsFirstTime = 'IsFirstTime';
  static const IsMapType = "IsMapType";
  static const PreviousSearch = 'Previous_Search';
  static final Color secoundryFontColor = Colors.white;
  static const NoInternet = 'No internet connection !!!\nPlease, try again later.';
  static const SuccsessfullRiderProfile = 'Your Profile create Succsessfully';
  static const BaseImageUrl = 'assets/images/';
  static final appIcon = BaseImageUrl + "app_icon.png";
  static final buildingImageBack = BaseImageUrl + "building_image_back.png";
  static final buildingImage = BaseImageUrl + "building_image.png";
  static final mapImage2 = BaseImageUrl + "map_image2.jpg";
  static final mapImage3 = BaseImageUrl + "map_image3.jpg";
  static final carImage = BaseImageUrl + "car_image.png";
  static final userImage = BaseImageUrl + "userImage.png";
  static final startPin = BaseImageUrl + "map_pin_start_image.png";
  static final endPin = BaseImageUrl + "map_pin_end_image.png";
  static final user1 = BaseImageUrl + "1.jpg";
  static final user2 = BaseImageUrl + "2.jpg";
  static final user3 = BaseImageUrl + "3.jpg";
  static final user4 = BaseImageUrl + "4.jpg";
  static final user5 = BaseImageUrl + "5.jpg";
  static final user6 = BaseImageUrl + "6.jpg";
  static final user7 = BaseImageUrl + "7.jpg";
  static final user8 = BaseImageUrl + "8.jpg";
  static final user9 = BaseImageUrl + "9.jpg";
  static final star = BaseImageUrl + "star.png";
  static final gift = BaseImageUrl + "gift.png";
  static final coin = BaseImageUrl + "coin.png";
  static final mapCar = BaseImageUrl + "top_car.png";
  static final startmapPin = BaseImageUrl + "start_pin.png";
  static final endmapPin = BaseImageUrl + "end_pin.png";
  static final googleApiKey = "";
}

// Locale locale;
String locale = "en";

AllTextData allTextData;
