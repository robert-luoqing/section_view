import 'package:flutter/material.dart';
import 'package:section_view/section_view.dart';
import 'package:section_view_sample/countryModel.dart';
import 'dataUtil.dart';

class FullSectionList extends StatefulWidget {
  const FullSectionList({Key? key}) : super(key: key);

  @override
  _FullSectionListState createState() => _FullSectionListState();
}

class _FullSectionListState extends State<FullSectionList> {
  List<AlphabetHeader<CountryModel>> _countries = [];

  _loadCountry() async {
    var data = await loadCountriesFromAsset();
    setState(() {
      _countries = convertListToAlphaHeader(
          data, (item) => (item.name).substring(0, 1).toUpperCase());
    });
  }

  Future _onRefresh() async {
    await Future.delayed(const Duration(seconds: 3));
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
                enableSticky: true,
                alphabetAlign: Alignment.center,
                alphabetInset: const EdgeInsets.all(4.0),
                onRefresh: _onRefresh,
                refreshBuilder:
                    (isRefreshing, onRefresh, isBouncePhysic, child) {
                  if (isBouncePhysic) {
                    return SectionViewBouncingScrollRefresh(
                        isRefreshing: isRefreshing,
                        onRefresh: onRefresh,
                        refreshingText: "Refresh....",
                        pullToRefreshText: "Pull to refresh",
                        releaseToRefreshText: "Release to refresh");
                  } else {
                    return RefreshIndicator(
                        onRefresh: onRefresh, child: child ?? Container());
                  }
                },
                headerBuilder: (context, headerData, headerIndex) {
                  return Container(
                    color: const Color(0xFFF3F4F5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: Text(
                        headerData.alphabet,
                        style: const TextStyle(
                            fontSize: 18, color: Color(0xFF767676)),
                      ),
                    ),
                  );
                },
                itemBuilder:
                    (context, itemData, itemIndex, headerData, headerIndex) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: ListTile(
                        title: Text(itemData.name),
                        trailing: Text(itemData.phoneCode)),
                  );
                },
                alphabetBuilder:
                    (context, headerData, isCurrent, headerIndex) => isCurrent
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(9)),
                                child: Center(
                                    child: Text(
                                  headerData.alphabet,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ))))
                        : Text(
                            headerData.alphabet,
                            style: const TextStyle(color: Color(0xFF767676)),
                          ),
                tipBuilder: (context, headerData) {
                  return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xCC000000)),
                      width: 50,
                      height: 50,
                      child: Center(
                        child: Text(
                          headerData.alphabet,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 24),
                        ),
                      ));
                },
              ),
            ),
          ],
        ));
  }
}
