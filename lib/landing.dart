import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'result.dart';
import 'suggestion.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  var controller = TextEditingController();
  List suggestions = [];

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('landing')),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "검색어를 입력하세요",
                    )),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    child: const Text('검색'),
                    onPressed: () async {
                      String url =
                          'https://dapi.kakao.com/v2/local/search/keyword.json?query=${controller.text}';
                      Map<String, String> requestHeaders = {
                        "Authorization":
                            "KakaoAK 3b85b7ae01e255f4633411ac2f9ab65d"
                      };

                      var response = await http.get(Uri.parse(url),
                          headers: requestHeaders);
                      var responsInJson = json.decode(response.body);
                      var result = responsInJson['documents'];

                      if (result.length == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Result(name: result[0]['place_name'])));
                      } else {
                        suggestions.clear();
                        for (int i = 0; i < result.length; i++) {
                          suggestions.add((result[i]['place_name'] +
                              "," +
                              (result[i]['address_name'])));
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Suggestion(suggestions)));
                      }
                    })
              ],
            ),
          )),
    );
  }
}
