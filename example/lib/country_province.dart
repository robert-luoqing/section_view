import 'package:flutter/material.dart';
import 'package:section_view/section_view.dart';

class Country {
  Country(
      {required this.name, required this.abbreviate, required this.provinces});
  String name;
  String abbreviate;
  List<String> provinces;
}

class CountryAndProvince extends StatefulWidget {
  const CountryAndProvince({Key? key}) : super(key: key);

  @override
  _CountryAndProvinceState createState() => _CountryAndProvinceState();
}

class _CountryAndProvinceState extends State<CountryAndProvince> {
  final data = [
    Country(name: "The United States", abbreviate: "US", provinces: []),
    Country(name: "The United Kingdom ", abbreviate: "UK", provinces: []),
    Country(name: "Chinse", abbreviate: "CN", provinces: []),
    Country(name: "Janpan", abbreviate: "JP", provinces: []),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Example")),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: SectionView<Country, String>(
                  source: data,
                  onFetchListData: (header) => header.provinces,
                  headerBuilder: (context, headerData, headerIndex) =>
                      Container(
                        color: const Color(0xFFF3F4F5),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            headerData.name,
                            style: const TextStyle(
                                fontSize: 18, color: Color(0xFF767676)),
                          ),
                        ),
                      ),
                  itemBuilder:
                      (context, itemData, itemIndex, headerData, headerIndex) =>
                          ListTile(
                            title: Text(itemData),
                          )),
            ),
          ],
        ));
  }
}
