import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({Key key}) : super(key: key);

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 50,
          width: 50,
          child: LoadingIndicator(
              indicatorType: Indicator.ballClipRotatePulse, /// Required, The loading type of the widget
              colors: [Theme.of(context).primaryColor],     /// Optional, The color collections
              strokeWidth: 6,                               /// Optional, The stroke of the line, only applicable to widget which contains line
              backgroundColor: Colors.white,                /// Optional, Background of the widget
              pathBackgroundColor: Colors.black             /// Optional, the stroke backgroundColor
          ),
        ),
        SizedBox(width: 6,),
        Container(
          child: Text(
            "Please wait...",
            style: Theme.of(context).textTheme.subtitle1.copyWith(
              color: Theme.of(context).textTheme.subtitle1.color,
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),
          ),
        )
      ],
    );
  }
}
