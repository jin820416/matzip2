import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'dart:convert';

class Naver {
  late String name;

  Naver(name) {
    this.name = name;
  }

  Future<double> searchNaver() async {
    String url1 =
        'https://openapi.naver.com/v1/search/local.json?query=${this.name}';
    String clientId = 'qIILsu8YdZVVR1DtghG3';
    String clientSecret = "mCe2UlhQ1T";
    Map<String, String> requestHeaders = {
      "X-Naver-Client-Id": clientId,
      "X-Naver-Client-Secret": clientSecret
    };

    var response = await http.get(Uri.parse(url1), headers: requestHeaders);
    var responseinJson = json.decode(response.body);

    var response2 = await http.get(Uri.parse(
        "https://search.naver.com/search.naver?sm=tab_hty.top&where=nexearch&query=${this.name}"));
    var body = parser
        .parse(response2.body)
        .querySelector(".nx_place .biz_name_area .review .rating");
    var ratingString = body!.text;
    double rating = double.parse(ratingString);
    return rating;
  }
}
