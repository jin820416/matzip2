import 'package:flutter/material.dart';
import 'package:matzip/place_service.dart';

class AddressSearch extends SearchDelegate<Suggestion?> {
  AddressSearch(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }
  final sessionToken;
  late PlaceApiProvider apiClient;
  late String placeIdFromSuggestion;
  late String nameFromSuggestion;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          tooltip: "Clear",
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        tooltip: 'Back',
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: query == "" ? null : apiClient.fetchSuggestions(query, 'kr'),
        builder: (context, AsyncSnapshot<dynamic> snapshot) => query == ''
            ? Container(
                padding: const EdgeInsets.all(16.0),
                child: const Text("검색어를 입력하세요"))
            : snapshot.hasData
                ? ListView.builder(
                    itemBuilder: (context, index) => ListTile(
                      title: Text(
                          (snapshot.data[index] as Suggestion).description!),
                      onTap: () async {
                        close(context, snapshot.data[index] as Suggestion?);
                      },
                    ),
                    itemCount: snapshot.data.length,
                  )
                : Container(child: const Text("장소를 찾고 있습니다...")));
  }
}
