import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'dart:convert';

class Place {
  String? name;
  Place({
    this.name,
  });
  @override
  String toString() {
    return 'Place(name: $name)';
  }
}

class Suggestion {
  final String? placeId;
  final String? description;

  Suggestion({required this.placeId, required this.description});

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final client = Client();

  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  static final String androidKey = "AIzaSyA1_pOvTwazEFjHJDZKphOqPWcEvrv8_Vc";
  static final String iosKey = "";
  final apiKey = androidKey;

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/queryautocomplete/json?input=$input&components=country:ko&language=ko&key=$apiKey';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(
                placeId: p['place_id'], description: p['description']))
            .toList();
      }

      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }

      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Place> getPlaceDetailFromId(String? placeId) async {
    final request =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&sessiontoken=$sessionToken";
    final response = await client.get(Uri.parse(request));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final place = Place();
        place.name = result['result']['name'];
        return place;
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}
