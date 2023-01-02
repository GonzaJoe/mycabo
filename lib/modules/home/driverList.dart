import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mycabo/Language/appLocalizations.dart';
import 'package:mycabo/constance/constance.dart';
import 'package:mycabo/dataHandler/appData.dart';
import 'package:mycabo/models/nearbyOnlineDriver.dart';
import 'package:provider/provider.dart';

class DriverList extends StatefulWidget {
  List<NearbyOnlineDriver> nearbyOnlineDriversList;
  String vehicleType;
  DriverList({this.nearbyOnlineDriversList,this.vehicleType});
  @override
  _DriverListState createState() => _DriverListState();
}

class _DriverListState extends State<DriverList> {
  List<NearbyOnlineDriver> nearbyOnlineDriverList;
  @override
  Widget build(BuildContext context) {
    nearbyOnlineDriverList = widget.nearbyOnlineDriversList;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            Navigator.of(context).pop();
          },
          child: SizedBox(
            child: Icon(
              Icons.close,
              color: Theme.of(context).textTheme.headline6.color,
            ),
          ),
        ),
        title: Text(
          'Choose Driver',
          style: Theme.of(context).textTheme.headline6.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.headline6.color,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: AppBar().preferredSize.height,
              color: Theme.of(context).disabledColor,
              child: Padding(
                padding: const EdgeInsets.only(right: 14, left: 14),
                child: Row(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of('There are ${nearbyOnlineDriverList.length} nearby ${widget.vehicleType} driver(s)'),
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ConstanceData.secoundryFontColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListView.builder(
              itemCount: nearbyOnlineDriverList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, index){
                return Padding(
                  padding: EdgeInsets.only(right: 6, left: 6, bottom: 10),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      //Navigator.push(context,MaterialPageRoute(builder: (context) => UserDetailScreen(userId: 1,),),);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(16),
                        color: Theme.of(context).dividerColor,
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(16), topStart: Radius.circular(16)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration:  BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage(nearbyOnlineDriverList[index].url),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 180,
                                        child: Text(
                                          nearbyOnlineDriverList[index].name,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.headline6.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).textTheme.headline6.color,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            height: 24,
                                            width: 74,
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of('Cash'),
                                                style: Theme.of(context).textTheme.button.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: ConstanceData.secoundryFontColor,
                                                ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Container(
                                            height: 24,
                                            width: 74,
                                            child: Center(
                                              child: Text(
                                                AppLocalizations.of('Discount'),
                                                style: Theme.of(context).textTheme.button.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: ConstanceData.secoundryFontColor,
                                                    ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(nearbyOnlineDriverList[index].gender),
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                          color: Theme.of(context).disabledColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            nearbyOnlineDriverList[index].rating.toStringAsFixed(1),
                                            style: Theme.of(context).textTheme.button.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).dividerColor.withOpacity(0.4),
                                            ),
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow[800],
                                            size: 18,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).dividerColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 14, left: 14, bottom: 8, top: 8),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of('PLATE NUMBER'),
                                      style: Theme.of(context).textTheme.caption.copyWith(
                                            color: Theme.of(context).disabledColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      AppLocalizations.of(nearbyOnlineDriverList[index].vehiclePlateNo),
                                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).textTheme.headline6.color,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 14, left: 14),
                            child: Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 14, left: 14, bottom: 8, top: 8),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of('CAR MODEL'),
                                      style: Theme.of(context).textTheme.caption.copyWith(
                                            color: Theme.of(context).disabledColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      AppLocalizations.of(nearbyOnlineDriverList[index].vehicleBrand+' - '+nearbyOnlineDriverList[index].vehicleModel),
                                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).textTheme.headline6.color,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width,
                            color: Theme.of(context).dividerColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 14, left: 14, top: 16),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  highlightColor: Colors.transparent,
                                  onTap: (){
                                    Navigator.pop(context,nearbyOnlineDriverList[index]);
                                  },
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of('REQUEST'),
                                      style: Theme.of(context).textTheme.button.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: ConstanceData.secoundryFontColor,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                );},
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom + 16,
            )
          ],
        ),
      ),
    );
  }
}
