import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class CreateSuggestions extends StatefulWidget {
  const CreateSuggestions({Key? key}) : super(key: key);

  @override
  State<CreateSuggestions> createState() => _CreateSuggestionsState();
}

class _CreateSuggestionsState extends State<CreateSuggestions> {
  Future<void> selectList(name) async {
    List suggestions = [];
    String url =
        'https://dapi.kakao.com/v2/local/search/keyword.json?query=${name}';
    Map<String, String> requestHeaders = {
      "Authorization": "KakaoAK 3b85b7ae01e255f4633411ac2f9ab65d"
    };

    var response = await http.get(Uri.parse(url), headers: requestHeaders);
    var responsInJson = json.decode(response.body);
    var result = responsInJson['documents'];

    if (result.length == 1) {
      print("result is one");
    } else {
      for (int i = 0; i < result.length; i++) {
        suggestions.add(
            (result[i]['place_name'] + ", " + (result[i]['address_name'])));
      }
    }

    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
