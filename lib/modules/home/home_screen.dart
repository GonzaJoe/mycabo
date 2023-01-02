import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/core/ripple_marker.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mycabo/assistants/assistantMethods.dart';
import 'package:mycabo/assistants/geoFireAssistants.dart';
import 'package:mycabo/assistants/mapKitAssistant.dart';
import 'package:mycabo/assistants/requestAssistants.dart';
import 'package:mycabo/constance/constance.dart';
import 'package:mycabo/constance/routes.dart';
import 'package:mycabo/dataHandler/appData.dart';
import 'package:mycabo/dataHandler/routes.dart';
import 'package:mycabo/main.dart';
import 'package:mycabo/constance/global.dart' as globals;
import 'package:mycabo/models/address.dart';
import 'package:mycabo/models/appUserInfo.dart';
import 'package:mycabo/models/directionDetails.dart';
import 'package:mycabo/models/nearbyOnlineDriver.dart';
import 'package:mycabo/models/newRideRequest.dart';
import 'package:mycabo/models/vehicleType.dart';
import 'package:mycabo/modules/auth/riderInfo.dart';
import 'package:mycabo/modules/drawer/drawer.dart';
import 'package:mycabo/modules/home/addressSelctionView.dart';
import 'package:mycabo/modules/home/requset_view.dart';
import 'package:mycabo/modules/home/ridingInfoView.dart';
import 'package:mycabo/modules/rating/rating_screen.dart';
import 'package:mycabo/modules/widgets/loadingWidget.dart';
import 'package:provider/provider.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  List<NearbyOnlineDriver> nearbyOnlineDriverList;
  bool isNearbyOnlineDriverKeysLoaded = false;
  Completer<GoogleMapController> mapControllerCompleter = Completer();
  Position currentPosition;
  BitmapDescriptor nearByIcon;
  BitmapDescriptor bodaIcon;
  BitmapDescriptor bajajIcon;
  BitmapDescriptor xCarIcon;
  BitmapDescriptor pickUpIcon;
  BitmapDescriptor dropOffIcon;
  StreamSubscription nearByVehiclesStreamSubscription;
  DatabaseReference rideRequestRef;
  String reqCode;
  String rideState;
  DateTime rideTime;
  String driverName;
  String driverPhone;
  String carRideType;
  String carDetailsDriver;
  String rideStatus;
  bool isRequestingPositionDetails = false;
  int driverRequestTimeout = 40;
  DirectionDetails rideDirectionDetails;
  AppUserInfo riderPersonalInfo;
  List faresList;
  LatLng point1;
  LatLng point2;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  static final CameraPosition _ochotaWarsaw = CameraPosition(
    target: LatLng(52.224331, 20.987591),
    zoom: 14.4746,
    tilt: 0.0
  );

  bool isSerchMode = false;
  bool isUp = true;
  String pickUpLocation;
  bool isAnimating = true;
  Set<Marker> animMarkersSet = {};
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};
  BitmapDescriptor carMapBitmapDescriptor;
  BitmapDescriptor startMapBitmapDescriptor;
  BitmapDescriptor endMapBitmapDescriptor;
  BuildContext currentcontext;
  bool isDriverActionsListeningStart = false;
  TextEditingController serachController = TextEditingController();
  bool isDomainLoaded = false;
  ProsseType prosseType = ProsseType.dropOff;
  String reqKey;
  int carOneIndex = 0, carTwoIndex = 0, carThreeIndex = 0, carFourIndex = 0, carFiveIndex = 0;
  List<LatLng> carPointOne = [], carPointTwo = [], carPointThree = [], carPointFour = [], carPointFive = [], poliList = [];
  Map<MarkerId, Marker> markers = {};

  @override
  initState() {
    animationController = new AnimationController(vsync: this, duration: Duration(milliseconds: 480));
    animationController..animateTo(1);
    super.initState();
    //completeRegCheck();
    //listenUserDetails();
    //resumeRideReq();
    //AssistanceMethod.getVehicleTypesList(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //setMakerPinSize(context);
    createCarMarker();
    createBodaMarker();
    createBajajMarker();
    createPickUpMarker();
    createDropOffMarker();
    riderPersonalInfo = Provider.of<AppData>(context,listen: false).appUserInfo;
    reqKey = Provider.of<AppData>(context,listen: false).currentRideRequestKey;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.72 : 350,
          child: Drawer(
            child: AppDrawer(
              selectItemName: 'Home',
              riderInfo: riderPersonalInfo,
            ),
          ),
        ),

        body: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height*0.25,
              child: GoogleMap(
                initialCameraPosition: _ochotaWarsaw,
                mapType: MapType.normal,
                markers: markersSet,
                //circles: circlesSet,
                polylines: polylineSet,
                compassEnabled: false,
                myLocationButtonEnabled: true,
                rotateGesturesEnabled: false,
                tiltGesturesEnabled: false,
                myLocationEnabled: true,
                buildingsEnabled: true,
                zoomControlsEnabled: false,
                onMapCreated: (GoogleMapController controller) async {
                  await getLocationPermission();
                  setState(() {
                    mapControllerCompleter.complete(controller);
                    //mapController = controller;
                  });
                  //setMapStyle();
                  await locateCurrentPosition();
                },
              ),
            ),

            Positioned(
              left: 10,
              top: 10,
              child: prosseType != ProsseType.requset ? _getAppBarUI(riderPersonalInfo) : SizedBox(),
            ),
            prosseType == ProsseType.dropOff
            ? AddressSelctionView(
                animationController: animationController,
                isSerchMode: isSerchMode,
                isUp: isUp,
                pickUpLocation: pickUpLocation,
                mapCallBack: () {
                  animationController.animateTo(1, duration: Duration(milliseconds: 480)).then((f) async {
                    await getPlaceDirection();
                    //await fareCalculator();
                    setState((){
                      //showLoadingDialog();
                      serachController.text = "";
                      print("why");
                      prosseType = ProsseType.requset;
                    });
                  });
                },
                onSerchMode: (onSerchMode) {
                  if (isSerchMode != onSerchMode) {
                    setState(() {
                      isSerchMode = onSerchMode;
                    });
                  }
                },
                onUp: (onUp) {
                  if (isUp != onUp) {
                    setState(() {
                      isUp = onUp;
                    });
                  }
                },
                serachController: serachController,
              )
              : prosseType == ProsseType.requset
                ?RequsetView(
                  rideDirectionDetails: rideDirectionDetails,
                  faresList:faresList,
                  onForward: () {
                    setState(() {
                      prosseType = ProsseType.riding;
                    });
                  },
                  onBack: (){
                    setState(() {
                      prosseType = ProsseType.dropOff;
                      resetAppAfterRide();
                    });
                  },
                  onLooping: () async {
                    updateCameraLocation(point1,point2);
                  }
                )
                :RidingInfoView(
                  onBack: () {
                    Future.delayed(Duration.zero, () async {
                      setState(() {
                        prosseType = ProsseType.dropOff;
                        resetAppAfterRide();
                      });
                    });
                  },
                onLooping: () async {
                  updateCameraLocation(point1,point2);
                }
                )
          ],
        ),
      ),
    );
  }

  Widget _getAppBarUI(AppUserInfo riderPersonalInfo) {
    return InkWell(
      onTap: () {
        _scaffoldKey.currentState.openDrawer();
      },
      child:CircleAvatar(
        radius: 24,
        backgroundColor: Theme.of(context).primaryColor,
        backgroundImage:  riderPersonalInfo != null
        ?Image.network(riderPersonalInfo.dpURL,).image
        :AssetImage(ConstanceData.userImage,),
      ),
    );
  }

  void setMapStyle() async {
    GoogleMapController mapController = await mapControllerCompleter.future;
    if (mapController != null) {
      if (globals.isLight)
        mapController.setMapStyle(await DefaultAssetBundle.of(context).loadString("assets/jsonFile/light_mapstyle.json"));
      else
        mapController.setMapStyle(await DefaultAssetBundle.of(context).loadString("assets/jsonFile/dark_mapstyle.json"));
    }
  }


  Future<void> locateCurrentPosition() async {
    //obtain user current pos
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    print("currentPosition");
    print(currentPosition);

    // move map camera to current user pos
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: latLngPosition, zoom: 18, tilt: 0.0, bearing: 0.0);
    GoogleMapController mapController = await mapControllerCompleter.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Future<void> getPlaceDirection()async{
    markersSet.clear();
    polylineSet.clear(); // clear a polyline set before add a new set
    Set<Polyline> orgDestPolylines = {};
    //await locateCurrentPosition();
    Address initialPos = Provider.of<AppData>(context,listen: false).pickUpLocation;
    Address finalPos = Provider.of<AppData>(context,listen: false).dropOffLocation;
    LatLng pickUpLatLng = LatLng(52.224331,20.987591);
    LatLng dropOffLatLng = LatLng(52.400188,16.927549); //52.03457,18.877099
    setState(() {
      point1 = pickUpLatLng;
      point2 = dropOffLatLng;
    });


    print("This is decoded points ::");
    DirectionDetails details = DirectionDetails();
    details.encodedPoints = "i~gcCyvm`I{uGkjEevi@`}BkoyAvwr@kxc@h_Cg|u@yaS~vw@_kaGmaKuwo@~dGo_TeuC{wl@dlQar`ChmLmpa@xqk@inXbrGktRwnlAszjAxwOcjXpuc@qvfBgiXyak@tgMulZriq@qlf@zyq@_oGrgMexQrcY{tKbmh@`jElkj@pjQ`wx@rp@ptz@j{^jnv@lhmAzei@|jXtbd@hvv@~z`@`uRtrVjx_AgNhfiB`gSrr_AhkoAp||AlqzAj_`Al|yAd|@hpeAv|JboXurIrwLdnCyoD`uF`h@btrAbf[xsk@aupAr{w@tuK|amAcaFfwFuqfCb~TqmGdhN|pCpti@_gx@piZ}~Hl~B|fbA_i^}pCqti@trG}iNplfCk|Tr_FatFlbRxys@~fV~qTng[ep_@xqk@ylH";
    details.startLatlng = LatLng(52.224331,20.987591);
    details.endLatlng = LatLng(52.400188,16.927549);

    // decode polyline from google format to flutter_polyline_points formats
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult = polylinePoints.decodePolyline(details.encodedPoints);
    pLineCoordinates.clear(); // clear pLine coordinates list
    if(decodedPolyLinePointsResult.isNotEmpty){
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates.add(LatLng(pointLatLng.latitude,pointLatLng.longitude));
        print(pLineCoordinates);
      });
    }

    Polyline polyline = Polyline( //create a polyline for each point
        color: Theme.of(context).primaryColor,
        polylineId: PolylineId("PolylineId"),
        jointType: JointType.round,
        points: [LatLng(52.224331,20.987591),LatLng(51.7687323,19.4569911),LatLng(52.400188,16.927549)],
        width: 10,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true
    );
    orgDestPolylines.add(polyline); // create a set of polyline for each polyline point
    //polyline.points.addAll(pLineCoordinates);

    Polyline polyline1 = Polyline( //create a polyline for each point
        color: Theme.of(context).primaryColor,
        polylineId: PolylineId("PolylineId1"),
        jointType: JointType.round,
        patterns: [PatternItem.dot, PatternItem.gap(5)],
        points: [pickUpLatLng,details.startLatlng],
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true
    );
    orgDestPolylines.add(polyline1);

    Polyline polyline2 = Polyline( //create a polyline for each point
        color: Theme.of(context).primaryColor,
        polylineId: PolylineId("PolylineId2"),
        jointType: JointType.round,
        patterns: [PatternItem.dot, PatternItem.gap(5)],
        points: [dropOffLatLng,details.endLatlng],
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true
    );
    orgDestPolylines.add(polyline2);
    setState(() {
      print("no no no");
      print(orgDestPolylines);
      polylineSet.addAll(orgDestPolylines);
    });

    // fit a polyline on map
    LatLngBounds latLngBound;
    if(pickUpLatLng.latitude>dropOffLatLng.latitude && pickUpLatLng.longitude>dropOffLatLng.longitude){
      latLngBound = LatLngBounds(southwest: dropOffLatLng,northeast: pickUpLatLng);
    }
    else if(pickUpLatLng.longitude>dropOffLatLng.longitude){
      latLngBound = LatLngBounds(southwest: LatLng(pickUpLatLng.latitude,dropOffLatLng.longitude),northeast: LatLng(dropOffLatLng.latitude,pickUpLatLng.longitude));
    }
    else if(pickUpLatLng.latitude>dropOffLatLng.latitude){
      latLngBound = LatLngBounds(southwest: LatLng(dropOffLatLng.latitude,pickUpLatLng.longitude),northeast: LatLng(pickUpLatLng.latitude,dropOffLatLng.longitude));
    }
    else{
      latLngBound = LatLngBounds(southwest: pickUpLatLng,northeast: dropOffLatLng);
    }
    GoogleMapController mapController = await mapControllerCompleter.future;
    mapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBound, 70)); // setup camera to view whole route
    //Adding final and initial position markers
    Marker pickUpLocMaker = drawMaker("pickUp","ochota,Warsaw","pickup location",pickUpIcon,pickUpLatLng);
    Marker dropOffLocMaker = drawMaker("dropOff","Lublin,Poland","dropOff location",dropOffIcon,dropOffLatLng);
    setState(() {
      polylineSet.addAll(orgDestPolylines);
      markersSet.add(pickUpLocMaker);
      markersSet.add(dropOffLocMaker);
    });
  }


  Marker drawMaker(String id,String placeName,String snip,BitmapDescriptor icon,LatLng pos){
    return Marker(
        icon: icon,
        infoWindow: InfoWindow(title: placeName,snippet: snip),
        position: pos,
        markerId: MarkerId(id),
        anchor: const Offset(0.5, 0.5)
    );
  }


  void updateOnlineDriversOnMap(){
    for(NearbyOnlineDriver driver in GeoFireAssistants.nearByOnlineDriversList){
      LatLng driverAvailablePosition = LatLng(driver.latitude,driver.longitude);
      BitmapDescriptor vehicleRepIcon;
      if(driver.bookingNo == 1){
        vehicleRepIcon = bodaIcon;
      }
      else if(driver.bookingNo == 2){
        vehicleRepIcon = bajajIcon;
      }
      else if(driver.bookingNo == 3){
        vehicleRepIcon = xCarIcon;
      }
      else{
        vehicleRepIcon = xCarIcon;
      }
      Marker marker = Marker(
          markerId: MarkerId('driver${driver.key}'),
          position: driverAvailablePosition,
          icon: vehicleRepIcon,
          rotation: AssistanceMethod.createRandomNumber(360)
      );
      setState(() {
        markersSet.removeWhere((marker) => marker.markerId.value == 'driver${driver.key}');
        markersSet.add(marker);
      });
    }
  }

  void createCarMarker(){
    if(xCarIcon == null){
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context,size:Size(1.4,1.4));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "assets/images/xCarTopView.png").then((value){
        setState(() {
          xCarIcon = value;
        });
      });
    }
  }
  
  void createBajajMarker(){
    if(bajajIcon == null){
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context,size:Size(10,10));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "assets/images/bajajTopView.png").then((value){
        setState(() {
          bajajIcon = value;
        });
      });
    }
  }

  void createBodaMarker(){
    if(bodaIcon == null){
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context,size:Size(1.4,1.4));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "assets/images/bodaTopView.png").then((value){
        setState(() {
          bodaIcon = value;
        });
      });
    }
  }

  void createPickUpMarker(){
    if(pickUpIcon == null){
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context,size:Size(1.4,1.4));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "assets/images/pickUp.png").then((value){
        setState(() {
          pickUpIcon = value;
        });
      });
    }
  }

  void createDropOffMarker(){
    if(dropOffIcon == null){
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context,size:Size(1.4,1.4));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "assets/images/dropOff.png").then((value){
        setState(() {
          dropOffIcon = value;
        });
      });
    }
  }

  void shiftPickDropMarker(String status, String addressName, LatLng latLng){
    if(status == "Accepted" || status == "Arrived" || status == "Confirmed"){
      Marker pickUpLocMaker = drawMaker("pickUp",addressName,"Pickup Location",pickUpIcon,latLng);
      setState(() {
        markersSet.removeWhere((marker) => marker.markerId.value == "dropOff");
        markersSet.add(pickUpLocMaker);
      });
    }
    else{
      Marker dropOffLocMaker = drawMaker("dropOff",addressName,"Drop-off Location",dropOffIcon,latLng);
      setState(() {
        markersSet.removeWhere((marker) => marker.markerId.value == "pickUp");
        markersSet.add(dropOffLocMaker);
      });
    }
  }

  Future<void> getLocationPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  Future<String> showRatingDialog(String driverId) async {
    return await showDialog(
      context: context,
      builder: (context)=>Dialog(
        insetPadding: EdgeInsets.all(20),
        child: RatingScreen(driverId: driverId),
      )
    );
  }

  void resetAppAfterRide(){
    Future.delayed(Duration.zero, () async {
      setState(() {
        isDriverActionsListeningStart = false;
        markersSet.clear();
        circlesSet.clear();
        polylineSet.clear();
        Provider.of<AppData>(context,listen: false).updateCurrentRideRequestKey("");
      });
      await locateCurrentPosition();
      updateOnlineDriversOnMap();
    });
  }

  Future<void> updateCameraLocation(LatLng source, LatLng destination) async {
    LatLngBounds bounds;
    GoogleMapController mapController = await mapControllerCompleter.future;

    if (source.latitude > destination.latitude &&
        source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70);

    return checkCameraLocation(cameraUpdate, mapController);
  }

  Future<void> checkCameraLocation(CameraUpdate cameraUpdate, GoogleMapController mapController) async {
    mapController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await mapController.getVisibleRegion();
    LatLngBounds l2 = await mapController.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }


  void showLoadingDialog(){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context){
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
          backgroundColor: Theme.of(context).backgroundColor,
          content: LoadingWidget(),
        );
      }
    );
  }
}

enum ProsseType {
  dropOff,
  requset,
  riding,
}
