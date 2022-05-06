import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'dart:convert';

class SearchNKG {
  late String name;

  SearchNKG(this.name);

  List queryList = [];
  Map resultMap = {'kakao': {}, 'naver': {}, 'google': {}};
  Map resultDetail = {
    'name': '',
    'nameFirst': '',
    'address': '',
    'addressFirst': '',
    'addressSecond': '',
    'addressThird': '',
    'searchFirst': '',
    'searchSecond': '',
    'searchThird': ''
  };

  void selectList() {}

  Future<void> searchKakaoApi(name) async {
    String url =
        'https://dapi.kakao.com/v2/local/search/keyword.json?query=$name}';
    Map<String, String> requestHeaders = {
      "Authorization": "KakaoAK 3b85b7ae01e255f4633411ac2f9ab65d"
    };

    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    var responsInJson = json.decode(response.body);
    var result = responsInJson['documents'];

    resultMap['kakao']['name'] = result[0]['place_name'];
    resultMap['kakao']['address'] = result[0]['address_name'];

    resultMap['kakao']['nameFirst'] = resultMap['kakao']['name'].split(' ')[0];
    resultMap['kakao']['addressFirst'] =
        resultMap['kakao']['address'].split(' ')[0];
    resultMap['kakao']['addressFirst'] =
        resultMap['kakao']['address'].split(' ')[1];
    resultMap['kakao']['addressFirst'] =
        resultMap['kakao']['address'].split(' ')[2];
  }

  void searchNaverApi() {}
  void createQuery() {}
  void searchKakaoWeb() {}
  void searchNaverWeb() {}
  void searchGoogleApi() {}

  Future<Map> searchAll() async {
    resultMap['kakao'] = resultDetail;
    resultMap['naver'] = resultDetail;
    resultMap['google'] = resultDetail;

    return resultMap;
  }

  Future<String> searchNaver() async {
    String rating;
    String naverName;
    var addressLevelOne;
    var addressLevelTwo;
    var addressLevelThree;
    // 네이버 api 정보 가져오기
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
    print("from naver api");
    print(responseinJson);
    addressLevelOne = responseinJson["items"][0]["address"].split(' ')[0];
    addressLevelTwo = responseinJson["items"][0]["address"].split(' ')[1];
    addressLevelThree = responseinJson["items"][0]["address"].split(' ')[2];
    naverName = responseinJson["items"][0]["title"]
        .replaceAll('<b>', "")
        .replaceAll("</b>", "");
    print(addressLevelOne);
    print(addressLevelTwo);
    print(addressLevelThree);
    print(naverName);
    String nameWithAddressOne = naverName + " " + addressLevelOne;
    String nameWithAddressTwo = nameWithAddressOne + " " + addressLevelTwo;
    String nameWithAddressThree = nameWithAddressTwo + " " + addressLevelThree;

    // 네이버 별점 크롤링 - 반복문 필요
    var response2 = await http.get(Uri.parse(
        "https://search.naver.com/search.naver?sm=tab_hty.top&where=nexearch&query=${this.name}"));
    var body = parser
        .parse(response2.body)
        .querySelector(".nx_place .biz_name_area .review .rating");
    if (body != null) {
      rating = body.text;
    } else {
      var response2 = await http.get(Uri.parse(
          "https://search.naver.com/search.naver?sm=tab_hty.top&where=nexearch&query=$nameWithAddressThree"));
      var body = parser
          .parse(response2.body)
          .querySelector(".nx_place .biz_name_area .review .rating");
      if (body != null) {
        rating = body.text;
        print(rating);
      } else {
        var response2 = await http.get(Uri.parse(
            "https://search.naver.com/search.naver?sm=tab_hty.top&where=nexearch&query=$nameWithAddressTwo"));
        var body = parser
            .parse(response2.body)
            .querySelector(".nx_place .biz_name_area .review .rating");
        if (body != null) {
          rating = body.text;
          print(rating);
        } else {
          var response2 = await http.get(Uri.parse(
              "https://search.naver.com/search.naver?sm=tab_hty.top&where=nexearch&query=$nameWithAddressOne"));
          var body = parser
              .parse(response2.body)
              .querySelector(".nx_place .biz_name_area .review .rating");
          if (body != null) {
            rating = body.text;
          } else {
            rating = "결과가 없습니다";
          }
        }
      }
    }
    return rating;
  }

  Future<String> searchKakao() async {
    double rating;
    String kakaoName;
    // 카카오 api 정보 가져오기
    String url =
        'https://dapi.kakao.com/v2/local/search/keyword.json?query=${this.name}}';
    Map<String, String> requestHeaders = {
      "Authorization": "KakaoAK 3b85b7ae01e255f4633411ac2f9ab65d"
    };

    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    var responsInJson = json.decode(response.body);
    var result = responsInJson['documents'];
    print('from kakao api');
    print(result.length);
    var url2 = result[0]['place_url'];
    kakaoName = result[0]['place_name'];
    print(result[0]['id']);
    print(kakaoName);

    // 카카오 크롤링
    String url3 = 'https://search.daum.net/search?q=$kakaoName';
    var response2 = await http.get(Uri.parse(url3));
    var body = parser.parse(response2.body).getElementsByClassName('txt_info');
    print('kakao crawling');
    print(body[0].text);

    return body[0].text.trim();
  }

  Future<String> searchGoogle() async {
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
    String rateGoogleStr = rateGoogleInt.toString();
    return rateGoogleStr;
  }
}
