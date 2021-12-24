import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:section_view/section_view.dart';
import 'package:section_view_sample/countryModel.dart';

import 'dataUtil.dart';

class CountryListWithSearch extends StatefulWidget {
  const CountryListWithSearch({Key? key}) : super(key: key);

  @override
  _CountryListWithSearchState createState() => _CountryListWithSearchState();
}

class _CountryListWithSearchState extends State<CountryListWithSearch> {
  late TextEditingController _textController;
  List<CountryModel> _allCountries = [];
  List<AlphabetHeader<CountryModel>> _filterCountries = [];

  _loadCountry() async {
    _allCountries = await loadCountriesFromAsset();
    _constructAlphabet(_allCountries);
  }

  _constructAlphabet(Iterable<CountryModel> data) {
    var _countries = convertListToAlphaHeader<CountryModel>(
        data, (item) => (item.name).substring(0, 1).toUpperCase());
    setState(() {
      _filterCountries = _countries;
    });
  }

  _didSearch() {
    var keywork = _textController.text.trim().toLowerCase();
    var filterCountries = _allCountries
        .where((item) => item.name.toLowerCase().contains(keywork));
    _constructAlphabet(filterCountries);
  }

  Future _onRefresh() async {
    await Future.delayed(const Duration(seconds: 3));
  }

  @override
  void initState() {
    _loadCountry();

    _textController = TextEditingController(text: '');
    _textController.addListener(_didSearch);
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Countries")),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
              child: CupertinoSearchTextField(controller: _textController),
            ),
            Expanded(
              flex: 1,
              child: SectionView<AlphabetHeader<CountryModel>, CountryModel>(
                source: _filterCountries,
                onFetchListData: (header) => header.items,
                enableSticky: true,
                alphabetAlign: Alignment.center,
                alphabetInset: const EdgeInsets.all(4.0),
                headerBuilder: getDefaultHeaderBuilder((d) => d.alphabet),
                alphabetBuilder: getDefaultAlphabetBuilder((d) => d.alphabet),
                tipBuilder: getDefaultTipBuilder((d) => d.alphabet),
                onRefresh: _onRefresh,
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
