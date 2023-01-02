// import 'package:country_pickers/country.dart';
// import 'package:country_pickers/country_pickers.dart';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mycabo/Language/appLocalizations.dart';
import 'package:mycabo/assistants/assistantMethods.dart';
import 'package:mycabo/constance/constance.dart';
import 'package:mycabo/constance/global.dart' as globals;
import 'package:mycabo/constance/themes.dart';
import 'package:mycabo/main.dart';
import 'package:mycabo/modules/home/home_screen.dart';

class RiderInfo extends StatefulWidget {
  @override
  _RiderInfoState createState() => _RiderInfoState();
}

class _RiderInfoState extends State<RiderInfo>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  TextEditingController nameTextEditingController = TextEditingController();
  String gender = 'Male';
  File croppedImageFile = null;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animationController..forward();
  }

  @override
  Widget build(BuildContext context) {
    globals.locale = Localizations.localeOf(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            minWidth: MediaQuery.of(context).size.width),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: ClipRect(
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: AnimatedBuilder(
                            animation: animationController,
                            builder: (BuildContext context, Widget child) {
                              return Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  Transform(
                                    transform: new Matrix4.translationValues(
                                      0.0,
                                      160 *(1.0 -(AlwaysStoppedAnimation(Tween(begin: 0.4,end: 1.0).animate(CurvedAnimation(parent:animationController,curve: Curves.fastOutSlowIn))).value).value) -16,
                                      0.0
                                    ),
                                    child: Image.asset(
                                      ConstanceData.buildingImageBack,
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                  ),
                                  Transform(
                                    transform: new Matrix4.translationValues(
                                        0.0,
                                        160 *
                                            (1.0 -
                                                (AlwaysStoppedAnimation(Tween(
                                                                begin: 0.8,
                                                                end: 1.0)
                                                            .animate(CurvedAnimation(
                                                                parent:
                                                                    animationController,
                                                                curve: Curves
                                                                    .fastOutSlowIn)))
                                                        .value)
                                                    .value),
                                        0.0),
                                    child: Image.asset(
                                      ConstanceData.buildingImageBack,
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: SizedBox()
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.all(0.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: (MediaQuery.of(context).size.height/2.2) -(MediaQuery.of(context).size.height < 600 ? 124 : 100),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        margin: EdgeInsets.all(0),
                        elevation: 8,
                        child: Column(
                          children: <Widget>[
                            Divider(
                              height: 1,
                            ),
                            Column(
                              children: <Widget>[
                                _headerUI(),
                                _driverAvator(),
                                _userNameUI(),
                                _genderUI(),
                                _nextButtonUI(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _driverAvator(){
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        onTap: () async {
          FilePickerResult result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['jpg', 'png', 'jpeg'],
          );
          print(result.files[0].path);
          File croppedFile = await ImageCropper().cropImage(
              sourcePath: result.files.single.path,
              cropStyle: CropStyle.circle,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                // CropAspectRatioPreset.ratio3x2,
                // CropAspectRatioPreset.original,
                // CropAspectRatioPreset.ratio4x3,
                // CropAspectRatioPreset.ratio16x9
              ],
              androidUiSettings: AndroidUiSettings(
                  toolbarTitle: 'Crop your Image',
                  toolbarColor: Theme.of(context).primaryColor,
                  toolbarWidgetColor: Colors.white,
                  initAspectRatio: CropAspectRatioPreset.square,
                  hideBottomControls: true,
                  lockAspectRatio: false),
              iosUiSettings: IOSUiSettings(
                minimumAspectRatio: 1.0,
              )
          );
          setState(() {
            croppedImageFile = croppedFile;
          });
        },
        child: croppedImageFile == null
        ? Image.asset(
          "assets/images/userImage.png",
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        )
        :Image.file(
          croppedImageFile,
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _genderUI(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0,8,16.0,16.0),
      child: Container(
        width: double.maxFinite,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(38)),
          border: Border.all(color: Theme.of(context).dividerColor, width: 0.6),
        ),
        child: Center(
          child: DropdownButton(
            value: gender,
            underline: Container(),
            items: <String>['Male', 'Female'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value){
              setState(() {
                gender = value;
              });
            }
          ),
        ),
      ),
    );
  }

  Widget _userNameUI() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0,16.0,16.0,8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(38)),
          border: Border.all(color: Theme.of(context).dividerColor, width: 0.6),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Container(
            height: 48,
            child: Center(
              child: TextField(
                maxLines: 1,
                onChanged: (String txt) {},
                cursorColor: Theme.of(context).primaryColor,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.name,
                controller: nameTextEditingController,
                decoration: new InputDecoration(
                  errorText: null,
                  border: InputBorder.none,
                  hintText: "Full Name",
                  hintStyle: TextStyle(color: Theme.of(context).disabledColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 16, top: 15, bottom: 15),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          AppLocalizations.of('Rider Details'),
          style: Theme.of(context).textTheme.bodyText2.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 15
          ),
        ),
      ),
    );
  }

  Widget _nextButtonUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            highlightColor: Colors.transparent,
            onTap: () {
              saveUserDetails();
            },
            child: Center(
              child: Text(
                AppLocalizations.of('Next'),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void saveUserDetails() async {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomeScreen()),(route)=>false);
  }
}
