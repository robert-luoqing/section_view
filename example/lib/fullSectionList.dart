import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:section_view/section_view.dart';
import 'package:section_view_sample/countryModel.dart';
import 'dataUtil.dart';

class FullSectionList extends StatefulWidget {
  const FullSectionList({Key? key}) : super(key: key);

  @override
  _FullSectionListState createState() => _FullSectionListState();
}

class _FullSectionListState extends State<FullSectionList> {
  final _refreshController = RefreshController(initialRefresh: false);
  List<AlphabetHeader<CountryModel>> _countries = [];

  _loadCountry() async {
    var data = await loadCountriesFromAsset();
    setState(() {
      _countries = convertListToAlphaHeader(
          data, (item) => (item.name).substring(0, 1).toUpperCase());
    });
  }

  Future _onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    _refreshController.refreshCompleted();
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
                refreshBuilder: (child) {
                  return SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: false,
                      header: const WaterDropHeader(),
                      footer: CustomFooter(
                        builder: (context, mode) {
                          Widget body;
                          if (mode == LoadStatus.idle) {
                            body = const Text("pull up load");
                          } else if (mode == LoadStatus.loading) {
                            body = const CupertinoActivityIndicator();
                          } else if (mode == LoadStatus.failed) {
                            body = const Text("Load Failed!Click retry!");
                          } else if (mode == LoadStatus.canLoading) {
                            body = const Text("release to load more");
                          } else {
                            body = const Text("No more Data");
                          }
                          return SizedBox(
                            height: 55.0,
                            child: Center(child: body),
                          );
                        },
                      ),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      // onLoading: _onLoading,
                      child: child);
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
