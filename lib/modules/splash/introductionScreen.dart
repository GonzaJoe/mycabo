import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:mycabo/Language/appLocalizations.dart';
import 'package:mycabo/modules/auth/loginScreen.dart';

class IntroductionScreen extends StatefulWidget {
  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  var pageController = PageController(initialPage: 0);
  var pageViewModelData = List<PageViewData>();

  Timer sliderTimer;
  var currentShowIndex = 0;

  @override
  void initState() {
    pageViewModelData.add(PageViewData(
      titleText: AppLocalizations.of('Choose your Driver'),
      subText: AppLocalizations.of('Choose your preferred driver\nfrom a pool of our drivers at you location'),
      assetsImage: 'assets/images/intro_1.png',
    ));

    pageViewModelData.add(PageViewData(
      titleText: AppLocalizations.of('Request Ride'),
      subText: AppLocalizations.of("Hail your chosen driver's ride\nto your location"),
      assetsImage: 'assets/images/intro_2.png',
    ));

    pageViewModelData.add(PageViewData(
      titleText: AppLocalizations.of('Track your ride'),
      subText: AppLocalizations.of('Know the location of your ride\nin realtime on map'),
      assetsImage: 'assets/images/intro_3.png',
    ));

    sliderTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (currentShowIndex == 0) {
        pageController.animateTo(MediaQuery.of(context).size.width, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
      } else if (currentShowIndex == 1) {
        pageController.animateTo(MediaQuery.of(context).size.width * 2, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
      } else if (currentShowIndex == 2) {
        pageController.animateTo(0, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    sliderTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Expanded(
              child: PageView(
                controller: pageController,
                pageSnapping: true,
                onPageChanged: (index) {
                  currentShowIndex = index;
                },
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  PagePopup(imageData: pageViewModelData[0]),
                  PagePopup(imageData: pageViewModelData[1]),
                  PagePopup(imageData: pageViewModelData[2]),
                ],
              ),
            ),
            PageIndicator(
              layout: PageIndicatorLayout.WARM,
              size: 10.0,
              controller: pageController,
              space: 5.0,
              count: 3,
              color: Theme.of(context).dividerColor,
              activeColor: Theme.of(context).primaryColor,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 48, right: 48, bottom: 8, top: 32),
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
                      Navigator.push(context,MaterialPageRoute(builder: (context) => LoginScreen(),));
                    },
                    child: Center(
                      child: Text(
                        AppLocalizations.of('Get Started!'),
                        style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16 + MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }
}

class PagePopup extends StatelessWidget {
  final PageViewData imageData;

  const PagePopup({Key key, this.imageData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 14, left: 14),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width - 120,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    imageData.assetsImage,
                    //fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: <Widget>[
                Text(
                  imageData.titleText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  imageData.subText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle1,
                )
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}

class PageViewData {
  final String titleText;
  final String subText;
  final String assetsImage;

  PageViewData({this.titleText, this.subText, this.assetsImage});
}
