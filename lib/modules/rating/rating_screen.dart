import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mycabo/Language/appLocalizations.dart';
import 'package:mycabo/dataHandler/appData.dart';
import 'package:mycabo/main.dart';
import 'package:mycabo/models/nearbyOnlineDriver.dart';
import 'package:provider/provider.dart';

class RatingScreen extends StatefulWidget {
  String driverId;
  RatingScreen({this.driverId});
  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  NearbyOnlineDriver selectedDriver;
  double rate = 0.0;
  @override
  Widget build(BuildContext context) {
    selectedDriver = Provider.of<AppData>(context,listen: true).selectedNearbyDriver;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            AppLocalizations.of('Rating'),
            style: Theme.of(context).textTheme.headline5.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(14),
          child: Column(
            children: <Widget>[
              Expanded(
                child: SizedBox(),
              ),
              SizedBox(
                height: 400,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,32.5,8.0,8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of(selectedDriver.name),
                                    style: Theme.of(context).textTheme.headline6.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Text(
                                AppLocalizations.of('How is your ride?'),
                                style: Theme.of(context).textTheme.headline4.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                AppLocalizations.of('Your feedback will help improve\nmy driving experience'),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              RatingBar.builder(
                                initialRating: 0.5,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    rate = rating;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                AppLocalizations.of(rate.toString().padLeft(2,"0")),
                                style: Theme.of(context).textTheme.headline6.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.all(Radius.circular(24.0)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Theme.of(context).dividerColor,
                                        blurRadius: 8,
                                        offset: Offset(4, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.all(Radius.circular(24.0)),
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        print("why");
                                        updateRatings();
                                      },
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of('Submit Review'),
                                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Container(
                          color: Theme.of(context).cardColor,
                          padding: EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(65),
                            child: Container(
                              height: 65,
                              width: 65,
                              decoration:  BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(selectedDriver.url),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void updateRatings(){
    double myRatings = selectedDriver.rating + rate;
    driverRef.child(selectedDriver.key).child("personalInfo").child("ratings").set(myRatings);
    Navigator.pop(context,"Rated");
  }
}
