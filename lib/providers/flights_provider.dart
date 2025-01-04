import 'package:flutter/widgets.dart';
import 'package:flutter_assessment/models/flights.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class FlightsProvider extends ChangeNotifier {
  static const apiEndpoint =
      'https://raw.githubusercontent.com/Skyscanner/full-stack-recruitment-test/main/public/flights.json';

  bool isLoading = true;

  String error = '';

  Flights flights = Flights(itineraries: [], legs: []);

  getDataFromApi() async {
    try {
      Response response = await http.get(Uri.parse(apiEndpoint));
      if (response.statusCode == 200) {
        flights = flightsFromJson(response.body);

      } else {
        error = response.statusCode.toString();
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}