import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestAssistance{
  static Future<dynamic> getRequest(String url) async {
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    try{
        if(response.statusCode == 200){
          String jsonBody = response.body;
          var decodeData = jsonDecode(jsonBody);
          return decodeData;
        }
        else{
          return "failed";
        }
    }
    catch(exp){
      return "failed";
    }
  }

  static Future<dynamic> postRequestWithDataWithHeader(String urls,Map body, header) async {
    var url = Uri.parse(urls);
    final jsonBodyString = json.encode(body);
    try{
      var response = await http.post(url, body: jsonBodyString, headers: header);
      print(response.body);
      if(response.statusCode == 200){
        return response.body;
      }
      else{
        return "failed";
      }
    }
    catch(exp){
      return "failed";
    }
  }
}