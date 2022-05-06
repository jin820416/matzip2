import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'dart:convert';

class SearchNKG {
  late String name;

  SearchNKG(this.name);

  late String kakaoRating;
  late String naverRating;
  late String googleRating;

  void createQuery(map, company) {
    map[company]['nameFirst'] = map[company]['name'].split(' ')[0];
    map[company]['addressFirst'] = map[company]['address'].split(' ')[0];
    map[company]['addressSecond'] = map[company]['address'].split(' ')[1];
    map[company]['addressThird'] = map[company]['address'].split(' ')[2];
    map[company]['searchFirst'] =
        map[company]['name'] + ' ' + map[company]['addressFirst'];
    map[company]['searchSecond'] =
        map[company]['searchFirst'] + ' ' + map[company]['addressSecond'];
    map[company]['searchThird'] =
        map[company]['searchSecond'] + ' ' + map[company]['addressThird'];
  }

  Future<void> selectList(name) async {
    String url =
        'https://dapi.kakao.com/v2/local/search/keyword.json?query=$name}';
    Map<String, String> requestHeaders = {
      "Authorization": "KakaoAK 3b85b7ae01e255f4633411ac2f9ab65d"
    };

    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    var responsInJson = json.decode(response.body);
    var result = responsInJson['documents'];
    print(result.length);
  }

  Future<Map> searchKakaoApi(map, name) async {
    String url =
        'https://dapi.kakao.com/v2/local/search/keyword.json?query=$name}';
    Map<String, String> requestHeaders = {
      "Authorization": "KakaoAK 3b85b7ae01e255f4633411ac2f9ab65d"
    };

    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    var responsInJson = json.decode(response.body);
    var result = responsInJson['documents'];

    map['kakao']['name'] = result[0]['place_name'];
    map['kakao']['address'] = result[0]['address_name'];

    createQuery(map, 'kakao');
    return map;
  }

  Future<Map> searchNaverApi(map, name) async {
    String url = 'https://openapi.naver.com/v1/search/local.json?query=$name';
    String clientId = 'qIILsu8YdZVVR1DtghG3';
    String clientSecret = "mCe2UlhQ1T";
    Map<String, String> requestHeaders = {
      "X-Naver-Client-Id": clientId,
      "X-Naver-Client-Secret": clientSecret
    };

    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    var responseinJson = json.decode(response.body);
    var result = responseinJson['items'];

    map['naver']['name'] =
        result[0]['title'].replaceAll('<b>', "").replaceAll("</b>", "");
    map['naver']['address'] = result[0]['address'];

    createQuery(map, 'naver');
    return map;
  }

  Future<String> crawlingKakao(list) async {
    String rating = "결과가 없습니다";
    for (int i = 0; i < list.length; i++) {
      String url = 'https://search.daum.net/search?q=${list[i]}';
      var response = await http.get(Uri.parse(url));
      var body = parser.parse(response.body).getElementsByClassName('txt_info');
      if (body[0].text != null) {
        rating = body[0].text.trim();
        break;
      }
    }
    return rating;
  }

  Future<String> crawlingNaver(list) async {
    String rating = "결과가 없습니다";
    for (int i = 0; i < list.length; i++) {
      String url =
          'https://search.naver.com/search.naver?sm=tab_hty.top&where=nexearch&query=${list[i]}';
      var response = await http.get(Uri.parse(url));
      var body = parser
          .parse(response.body)
          .querySelector(".nx_place .biz_name_area .review .rating");
      if (body != null) {
        rating = body.text;
        break;
      }
    }
    return rating;
  }

  Future<Map> searchGoogleApi(map, name, list) async {
    map['google']['rating'] = "결과가 없습니다";
    String url =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?&locationbias=circle:50000000@37.56019214,126.804312&query=$name&key=AIzaSyA1_pOvTwazEFjHJDZKphOqPWcEvrv8_Vc";

    var response = await http.get(Uri.parse(url));
    var responseInJson = json.decode(response.body);
    // print(responseInJson);

    map['google']['name'] = responseInJson['results'][0]['name'];
    map['google']['address'] =
        responseInJson['results'][0]['formatted_address'].replaceAll(',', "");
    map['google']['rating'] = responseInJson['results'][0]['rating'].toString();

    createQuery(map, 'google');
    return map;
  }

  Future<Map> searchAll(name) async {
    List queryList = [];
    Map ratings = {'naver': '', 'kakao': '', 'google': ''};
    Map resultMap = {
      'kakao': {
        'name': '',
        'nameFirst': '',
        'address': '',
        'addressFirst': '',
        'addressSecond': '',
        'addressThird': '',
        'searchFirst': '',
        'searchSecond': '',
        'searchThird': '',
        'rating': ''
      },
      'naver': {
        'name': '',
        'nameFirst': '',
        'address': '',
        'addressFirst': '',
        'addressSecond': '',
        'addressThird': '',
        'searchFirst': '',
        'searchSecond': '',
        'searchThird': '',
        'rating': ''
      },
      'google': {
        'name': '',
        'nameFirst': '',
        'address': '',
        'addressFirst': '',
        'addressSecond': '',
        'addressThird': '',
        'searchFirst': '',
        'searchSecond': '',
        'searchThird': '',
        'rating': ''
      }
    };

    selectList(name);
    resultMap = await searchKakaoApi(resultMap, name);
    resultMap = await searchNaverApi(resultMap, name);

    queryList.addAll([
      resultMap['kakao']['searchFirst'],
      resultMap['kakao']['searchSecond'],
      resultMap['kakao']['searchThird'],
      resultMap['naver']['searchFirst'],
      resultMap['naver']['searchSecond'],
      resultMap['naver']['searchThird']
    ]);

    resultMap = await searchGoogleApi(resultMap, name, queryList);

    // print(queryList);
    resultMap['kakao']['rating'] = await crawlingKakao(queryList);
    resultMap['naver']['rating'] = await crawlingNaver(queryList);
    // print(resultMap);
    ratings['naver'] = resultMap['naver']['rating'];
    ratings['kakao'] = resultMap['kakao']['rating'];
    ratings['google'] = resultMap['google']['rating'];
    kakaoRating = resultMap['naver']['rating'];
    naverRating = resultMap['naver']['rating'];
    googleRating = resultMap['google']['rating'];
    return ratings;
  }
}
