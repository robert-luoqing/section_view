import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:section_view_sample/countryModel.dart';

Future<List<CountryModel>> loadCountriesFromAsset() async {
  var value = await rootBundle.loadString('assets/countryCode.json');
  List<dynamic> _jsonData = json.decode(value);
  var result = <CountryModel>[];
  for (var item in _jsonData) {
    result.add(CountryModel(
        name: item["countryName"].toString(),
        countryCode: item["countryCode"].toString(),
        phoneCode: item["phoneCode"].toString()));
  }
  result.sort((a, b) => a.name.compareTo(b.name));
  return result;
}
