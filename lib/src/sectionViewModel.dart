import 'package:flutter/material.dart';

typedef SectionViewOnFetchListData<T, N> = List<N> Function(T sourceItem);
typedef SectionViewOnFetchAlphabet<T> = String Function(T header);
typedef SectionViewItemBuilder<T, N> = Widget Function(
  BuildContext context,
  N itemData,
  int itemIndex,
  T headerData,
  int headerIndex,
);
typedef SectionViewHeaderBuilder<T> = Widget Function(
    BuildContext context, T headerData, int headerIndex);

typedef SectionViewAlphabetBuilder<T> = Widget Function(
    BuildContext context, T headerData, bool isCurrent, int headerIndex);

typedef SectionViewTipBuilder<T> = Widget Function(
    BuildContext context, T headerData);

typedef SectionViewOnRefresh = Future Function();

typedef SectionViewRefreshWidgetBuilder = Widget Function(double offset);

typedef SectionViewRefreshBuilder = Widget Function(Widget? child);

typedef AlphabetItemOnTap<T> = void Function<T>(AlphabetModel<T> item);

List<AlphabetHeader<T>> convertListToAlphaHeader<T>(
    Iterable<T> data, SectionViewOnFetchAlphabet<T> onAlphabet) {
  List<AlphabetHeader<T>> result = [];
  Map<String, List<T>> map = {};
  for (var item in data) {
    var alphabet = onAlphabet(item);
    if (!map.containsKey(alphabet)) {
      var header = AlphabetHeader<T>(alphabet: alphabet, items: []);
      result.add(header);
      map[alphabet] = header.items;
    }
    map[alphabet]!.add(item);
  }

  return result;
}

class AlphabetModel<T> {
  AlphabetModel(
      {required this.mapIndex,
      required this.headerData,
      required this.headerIndex});

  /// [mapIndex] is used to indicate the index of list data
  int mapIndex;
  T headerData;

  /// [headerIndex] is the index of header list
  int headerIndex;
}

enum SectionViewDataType { dataHeader, dataItem }

class SectionViewData {
  SectionViewData(
      {required this.type,
      required this.headerIndex,
      required this.headerData,
      this.itemData,
      this.itemIndex});
  SectionViewDataType type;

  /// [headerIndex] is the index of header list
  int headerIndex;
  dynamic headerData;

  /// [itemIndex] is the index of header's list
  /// it is null if type is not dataItem
  int? itemIndex;

  /// it is null if type is not dataItem
  dynamic itemData;
}

class AlphabetHeader<T> {
  AlphabetHeader({required this.alphabet, required this.items});
  String alphabet;
  List<T> items;
}
