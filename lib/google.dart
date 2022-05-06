import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'dart:convert';

class Google {
  late String name;

  Google(name) {
    this.name = name;
  }

  Future<double> searchGoogle() async {
    double rateGoogle = 0.0;
    int rateGoogleInt = 0;

    String url =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?&locationbias=circle:50000000@37.56019214,126.804312&query=${this.name}&key=AIzaSyA1_pOvTwazEFjHJDZKphOqPWcEvrv8_Vc";

    var response = await http.get(Uri.parse(url));
    var responseInJson = json.decode(response.body);
    if (responseInJson['results'][0]['rating'].runtimeType == double) {
      rateGoogle = responseInJson['results'][0]['rating'];
    } else if (responseInJson['results'][0]['rating'].runtimeType == int) {
      rateGoogleInt = responseInJson['results'][0]['rating'];
      rateGoogle = rateGoogleInt.toDouble();
    }
    return rateGoogle;
  }
}

// https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=formatted_address%2Cname%2Crating%2Copening_hours%2Cgeometry&input=${this.name}&inputtype=textquery&key=AIzaSyA1_pOvTwazEFjHJDZKphOqPWcEvrv8_Vc
// https://maps.googleapis.com/maps/api/place/findplacefromtext/json?&locationbias=circle:50000000@37.56019214,126.804312&strictbounds&input=${this.name}&inputtype=textquery&key=AIzaSyA1_pOvTwazEFjHJDZKphOqPWcEvrv8_Vc;