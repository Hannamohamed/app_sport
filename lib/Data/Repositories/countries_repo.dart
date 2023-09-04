import 'dart:convert';
import 'package:flutter_fiers/Data/Models/countries_model.dart';
import 'package:http/http.dart' as http;

class CountriesRepo {
  Future<CountriesModel?> getCountries() async {
    try {
      var response = await http.get(
        Uri.parse(
            "https://apiv2.allsportsapi.com/football/?met=Countries&APIkey=9819e7462cfeeb44124fd5f716823bdf526bfc2f97353aa89ec3ff0441895eb3"),
      );
      var decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        CountriesModel myResponse = CountriesModel.fromJson(decodedResponse);
        return myResponse;
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }
}
