import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'dart:convert';

class Kakao {
  late String name;

  Kakao(name) {
    this.name = name;
  }

  Future<String> searchKakao() async {
    String url =
        'https://dapi.kakao.com/v2/local/search/keyword.json?query=${this.name}}';
    Map<String, String> requestHeaders = {
      "Authorization": "KakaoAK 3b85b7ae01e255f4633411ac2f9ab65d"
    };

    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    var responsInJson = json.decode(response.body);
    var result = responsInJson['documents'];
    print('kakao');
    print(result[0]);
    var url2 = result[0]['place_url'];

    var response2 = await http.get(Uri.parse(url2));
    var body = parser.parse(response2.body);
    print(response2.body);

    return 'well done';
  }
}
