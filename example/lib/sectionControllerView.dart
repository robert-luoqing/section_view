import 'package:flutter/material.dart';
import 'package:section_view/section_view.dart';
import 'package:section_view_sample/countryModel.dart';
import 'dataUtil.dart';

class SectionControllerView extends StatefulWidget {
  const SectionControllerView({Key? key}) : super(key: key);

  @override
  State<SectionControllerView> createState() => __SectionControllerViewState();
}

class __SectionControllerViewState extends State<SectionControllerView> {
  List<AlphabetHeader<CountryModel>> _countries = [];
  final FlutterListViewController controller = FlutterListViewController();

  _loadCountry() async {
    var data = await loadCountriesFromAsset();
    setState(() {
      _countries = convertListToAlphaHeader(
          data, (item) => (item.name).substring(0, 1).toUpperCase());
    });
  }

  _jumpToLatest() {
    int count = 0;
    for (var country in _countries) {
      count += (country.items.length + 1);
    }

    controller.sliverController.jumpToIndex(count - 1);
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
            ElevatedButton(
                onPressed: () {
                  _jumpToLatest();
                },
                child: const Text("Jump to latest")),
            Expanded(
              flex: 1,
              child: SectionView<AlphabetHeader<CountryModel>, CountryModel>(
                physics: const ClampingScrollPhysics(),
                controller: controller,
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
