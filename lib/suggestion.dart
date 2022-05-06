import 'package:flutter/material.dart';
import 'result.dart';

class Suggestion extends StatelessWidget {
  // const Suggestion({Key? key}) : super(key: key);

  final List suggestions;
  Suggestion(this.suggestions);

  late String selected;

  Map ratings = {'naver': '', 'kakao': '', 'google': ''};

  Widget createSuggestion() {
    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (BuildContext _context, int i) {
          return Card(
              child: ListTile(
            title: Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: suggestions[i].split(',')[0],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.0)),
                const TextSpan(text: "\n"),
                TextSpan(
                    text: "(" + suggestions[i].split(',')[1] + ")",
                    style: const TextStyle(fontSize: 14.0)),
              ]),
            ),
            onTap: () {
              selected = suggestions[i].split(',')[0];
              Navigator.push(
                  _context,
                  MaterialPageRoute(
                      builder: (context) => Result(name: selected)));
            },
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('suggestions page')),
      body: createSuggestion(),
    );
  }
}
