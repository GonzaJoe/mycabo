import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebOpenerWidget extends StatefulWidget {
  String webUrl;
  String webTitle;
  WebOpenerWidget({Key key,this.webUrl,this.webTitle,}) : super(key: key);

  @override
  _WebOpenerWidgetState createState() => _WebOpenerWidgetState();
}

class _WebOpenerWidgetState extends State<WebOpenerWidget> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.webTitle),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: widget.webUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (joel){
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading?Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: LinearProgressIndicator()
          ):Container()
        ],
      ),
    );
  }
}
