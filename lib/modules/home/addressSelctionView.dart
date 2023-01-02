import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:mycabo/Language/appLocalizations.dart';
import 'package:mycabo/assistants/requestAssistants.dart';
import 'package:mycabo/constance/constance.dart';
import 'package:mycabo/dataHandler/appData.dart';
import 'package:mycabo/models/address.dart';
import 'package:mycabo/models/placePredictions.dart';
import 'package:mycabo/modules/home/locationButton.dart';
import 'package:provider/provider.dart';

class AddressSelctionView extends StatefulWidget {
  final AnimationController animationController;
  final bool isUp, isSerchMode;
  final Function(bool) onUp, onSerchMode;
  final TextEditingController serachController;
  final VoidCallback mapCallBack;
  final String pickUpLocation;

  const AddressSelctionView(
      {Key key,
      this.animationController,
      this.isUp,
      this.onUp,
      this.isSerchMode,
      this.onSerchMode,
      this.serachController,
      this.mapCallBack,
      this.pickUpLocation,})
      : super(key: key);

  @override
  State<AddressSelctionView> createState() => _AddressSelctionViewState();
}

class _AddressSelctionViewState extends State<AddressSelctionView> {
  List<PlacePrediction> placePredictionList = [];
  String apiKey = ConstanceData.googleApiKey;
  GlobalKey<FormState> searchTextFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return Transform(
          transform: new Matrix4.translationValues(
              0.0,
              0.0 +
                  (((MediaQuery.of(context).size.height - MediaQuery.of(context).size.height*0.30))) *
                      ((AlwaysStoppedAnimation(
                                  Tween(begin: 0.15, end: 1.0).animate(CurvedAnimation(parent: widget.animationController, curve: Curves.fastOutSlowIn)))
                              .value)
                          .value),
              0.0),
          child: Stack(
            children: [
              GestureDetector(
                onVerticalDragUpdate: (DragUpdateDetails gragEndDetails) {
                  if (gragEndDetails.delta.dy > 0) {
                    widget.onUp(false);
                  } else if (gragEndDetails.delta.dy < 0) {
                    widget.onUp(true);
                  }
                  final position = gragEndDetails.globalPosition.dy
                      .clamp(0, (MediaQuery.of(context).size.height - 220) + MediaQuery.of(context).padding.bottom) +
                      36 +
                      gragEndDetails.delta.dy;
                  final animatedPostion =
                      (position - 100) / ((MediaQuery.of(context).size.height - 220) + MediaQuery.of(context).padding.bottom);
                  widget.animationController.animateTo(animatedPostion, duration: Duration(milliseconds: 0));
                },
                onVerticalDragEnd: (DragEndDetails gragEndDetails) {
                  if (widget.isUp) {
                    widget.onSerchMode(true);
                    widget.animationController.animateTo(0, duration: Duration(milliseconds: 240));
                  } else {
                    widget.onSerchMode(false);
                    widget.animationController.animateTo(1, duration: Duration(milliseconds: 240));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(
                      color:Theme.of(context).primaryColor,
                      blurRadius: 5,
                      blurStyle: BlurStyle.outer
                    )]
                  ),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                  ),
                                  child: SizedBox(
                                    height: 4,
                                    width: 48,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Take me to",
                                style: Theme.of(context).textTheme.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            endIndent: 8,
                            indent: 8,
                            height: 1,
                          ),
                        ],
                      ),
                      Container(
                        color: Theme.of(context).cardColor,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 8, top: 10),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: Image.asset(
                                  "assets/images/pickUp.png"
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8, left: 10, right: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(AppLocalizations.of('Pickup'), style: Theme.of(context).textTheme.caption),
                                      SizedBox(height: 2.5,),
                                      Text(
                                        widget.pickUpLocation == null?AppLocalizations.of('Ochota,Warsaw'):widget.pickUpLocation,
                                        maxLines: 1,
                                        style: Theme.of(context).textTheme.subtitle2,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8,),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 8),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 30,
                              height: 30,
                              //child: Icon(Icons.location_pin,color: Colors.pinkAccent,)
                              child: Image.asset(
                                "assets/images/dropOff.png"
                              )
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8, right: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                        AppLocalizations.of('Drop-off'),
                                        style: Theme.of(context).textTheme.caption
                                    ),
                                    SizedBox(height: 2.5,),
                                    Container(
                                      height: 24,
                                      width: double.maxFinite,
                                      child: TextField(
                                        maxLines: 1,
                                        key: searchTextFormKey,
                                        style: Theme.of(context).textTheme.subtitle2,
                                        onChanged: (String txt) {
                                          if(txt != ""){
                                            findPlace(txt);
                                          }
                                        },
                                        onTap: (){
                                          maxDropOffSearchWidget();
                                          widget.serachController.text = "";
                                        },
                                        controller: widget.serachController,
                                        cursorColor: Theme.of(context).primaryColor,
                                        decoration: new InputDecoration.collapsed(
                                          //border: InputBorder.none,
                                          hintText: "Enter Drop Off Address",
                                          hintStyle: TextStyle(color: Theme.of(context).disabledColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: widget.isSerchMode?InkWell(
                                onTap: () {
                                  miniMaxDropOffSearchWidget();
                                  FocusScope.of(context).unfocus();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0,0,15,0),
                                  child: Icon(
                                    Icons.close,
                                    color: Theme.of(context).textTheme.headline6.color,
                                  ),
                                ),
                              ):SizedBox(),
                            ),
                          ],
                        ),
                      ),
                      Opacity(
                        opacity: 1 - widget.animationController.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              color: Theme.of(context).dividerColor.withOpacity(0.05),
                              height: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                              child: Text(AppLocalizations.of('POPULAR LOCATONS'), style: Theme.of(context).textTheme.caption),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height - 230,
                              child: ListView.builder(
                                padding: EdgeInsets.all(0.0),
                                itemCount: placePredictionList.length,
                                itemBuilder: (context, idx) {
                                  return GestureDetector(
                                    onTap: ()async{
                                      FocusScopeNode currentFocus = FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      miniMaxDropOffSearchWidget();
                                      widget.serachController.text = placePredictionList[idx].main_text;
                                      await getDropOffAddressDetails(placePredictionList[idx].place_id,context);
                                      widget.mapCallBack();
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: <Widget>[
                                              SizedBox(width: 22, height: 22, child: Image.asset(ConstanceData.endPin)),
                                              SizedBox(width: 4,),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        (placePredictionList[idx].main_text != null)?placePredictionList[idx].main_text:"",
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(fontSize: 16.0),
                                                        //style: Theme.of(context).textTheme.bodyText1,
                                                      ),
                                                      SizedBox(height: 3.0,),
                                                      Text(
                                                        (placePredictionList[idx].secondary_text != null)?placePredictionList[idx].secondary_text:"",
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(fontSize: 12.0,color: Colors.grey),
                                                        //style: Theme.of(context).textTheme.bodyText1,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Icon(Icons.star_border,color: Theme.of(context).disabledColor,),
                                              SizedBox(width: 4,),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          height: 1,
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left:34,
                top: 105,
                child: Dash(
                    direction: Axis.vertical,
                    length: 37,
                    dashLength: 2,
                    dashGap: 4,
                    dashThickness: 2,
                    dashColor: Theme.of(context).primaryColor,
                ),
              ),
              Positioned(
                left:0,
                top: 125,
                right: 0,
                child: IgnorePointer(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor,width: 2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void miniMaxDropOffSearchWidget(){
    if (widget.isSerchMode) {
      miniDropOffSearchWidget();
    } else {
      maxDropOffSearchWidget();
    }
  }

  void miniDropOffSearchWidget(){
    widget.onSerchMode(false);
    widget.animationController.animateTo(1, duration: Duration(milliseconds: 240));
  }

  void maxDropOffSearchWidget(){
    widget.onSerchMode(true);
    widget.serachController.text = '';
    widget.animationController.animateTo(0, duration: Duration(milliseconds: 240));
  }

  void findPlace(String placeName)async{
    List<Map<String,dynamic>> predictions = [
      {"place_id": "123", "structured_formatting": {"main_text": "Poznan, Poland", "secondary_text": "Poland"}},
      {"place_id": "123", "structured_formatting": {"main_text": "Poznan, Poland", "secondary_text": "Poland"}},
      {"place_id": "123", "structured_formatting": {"main_text": "Poznan, Poland", "secondary_text": "Poland"}},
      {"place_id": "123", "structured_formatting": {"main_text": "Poznan, Poland", "secondary_text": "Poland"}},
    ];
    var placesList = predictions.map((e) => PlacePrediction.fromJson(e)).toList();
    setState(() {
      print(placesList);
      placePredictionList = placesList;
    });
  }

  Future<void> getDropOffAddressDetails(String placeId,context)async{
    if(placeId != null){
      Address address = Address();
      address.placeName = "Poznan, Poland";
      address.placeId = "loc1";
      address.latitude = 52.400188;
      address.longitude = 16.927549;
      print("tako");
      Provider.of<AppData>(context,listen: false).updateDropOffLocation(address);
      print("This is drop Off location ::");
      print(address.placeName);
      //Navigator.pop(context,"ObtainDirection");
      //http://router.project-osrm.org/route/v1/driving/52.224331,20.987591;52.151750,21.052110;35.014720,78.225700?alternatives=false&annotations=nodes
    }
  }
}
