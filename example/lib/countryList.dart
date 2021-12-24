import 'package:flutter/material.dart';
import 'package:section_view/section_view.dart';
import 'package:section_view_sample/countryModel.dart';
import 'dataUtil.dart';

class CountryList extends StatefulWidget {
  const CountryList({Key? key}) : super(key: key);

  @override
  _CountryListState createState() => _CountryListState();
}

class _CountryListState extends State<CountryList> {
  List<AlphabetHeader<CountryModel>> _countries = [];

  _loadCountry() async {
    var data = await loadCountriesFromAsset();
    setState(() {
      _countries = convertListToAlphaHeader(
          data, (item) => (item.name).substring(0, 1).toUpperCase());
    });
  }

  @override
  void initState() {
    _loadCountry();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Countries")),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: SectionView<AlphabetHeader<CountryModel>, CountryModel>(
                source: _countries,
                onFetchListData: (header) => header.items,
                headerBuilder: getDefaultHeaderBuilder((d) => d.alphabet),
                alphabetBuilder: getDefaultAlphabetBuilder((d) => d.alphabet),
                tipBuilder: getDefaultTipBuilder((d) => d.alphabet),
                itemBuilder:
                    (context, itemData, itemIndex, headerData, headerIndex) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: ListTile(
                        title: Text(itemData.name),
                        trailing: Text(itemData.phoneCode)),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
