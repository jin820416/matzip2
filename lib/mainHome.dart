import 'package:flutter/material.dart';
import 'search.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> companies = ["naver", "kakao", "google"];
  Map<String, dynamic> ratings = {"naver": '', "kakao": '', "google": ''};
  var controller = TextEditingController();
  String? idFromSuggestion;
  String? nameFromSuggestion;
  String? _name;

  Future<Map<String, dynamic>> getResults(restaurante) async {
    SearchNKG search = SearchNKG(restaurante);
    search.searchAll(restaurante);

    // ratings["naver"] = await search.searchNaver();
    // ratings['kakao'] = await search.searchKakao();
    // ratings["google"] = await search.searchGoogle();

    setState(() {});

    return ratings;
  }

  Widget buildResults(company) {
    return ListTile(
      title: Text(
        company + " : " + ratings[company],
        // style: TextStyle(
        //     color: ratings[company] == 0.0 ? Colors.white : Colors.black),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('맛집비교')),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
              child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: controller,
                          readOnly: false,
                          // onTap: () async {
                          //   final sessionToken = Uuid().v4();
                          //   final Suggestion? result =
                          //       await showSearch<Suggestion?>(
                          //           context: context,
                          //           delegate: AddressSearch(sessionToken));
                          //   if (result != null) {
                          //     final placeDetails =
                          //         await PlaceApiProvider(sessionToken)
                          //             .getPlaceDetailFromId(result.placeId);
                          //     setState(() {
                          //       controller.text = result.description!;
                          //       _name = placeDetails.name;
                          //       print(result.description);
                          //       print(result.placeId);
                          //       print(placeDetails);
                          //     });
                          //   }
                          // },
                          onTap: () {},
                          decoration: InputDecoration(
                            icon: Container(
                              margin: const EdgeInsets.only(left: 20),
                              width: 10,
                              height: 10,
                              child: const Icon(
                                Icons.home,
                                color: Colors.black,
                              ),
                            ),
                            hintText: "검색어를 입력하세요",
                          ))),
                  ElevatedButton(
                      onPressed: () {
                        getResults(controller.text);
                      },
                      child: const Text('검색'))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // Text('name: $_name'),
              // Text("${ratings['naver']}"),
              Expanded(
                  child: ListView(
                      children: companies.map((e) => buildResults(e)).toList()))
            ],
          )),
        ));
  }
}
