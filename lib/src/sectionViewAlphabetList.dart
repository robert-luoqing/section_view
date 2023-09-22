import 'sectionViewModel.dart';
import 'package:flutter/material.dart';

class SectionViewAlphabetList<T> extends StatefulWidget {
  const SectionViewAlphabetList(
      {required this.headerToIndexMap,
      required this.onSelect,
      required this.alphabetAlign,
      required this.alphabetInset,
      this.alphabetBuilder,
      Key? key})
      : super(key: key);
  final SectionViewAlphabetBuilder<T>? alphabetBuilder;
  final List<AlphabetModel<T>> headerToIndexMap;
  final AlphabetItemOnTap<AlphabetModel<T>> onSelect;
  final Alignment alphabetAlign;
  final EdgeInsets alphabetInset;

  @override
  SectionViewAlphabetListState<T> createState() =>
      SectionViewAlphabetListState<T>();
}

class SectionViewAlphabetListState<T> extends State<SectionViewAlphabetList> {
  final List<GlobalKey> itemKeys = [];

  /// It is top item on viewport, the headerData can be used to tracking
  /// current alphabet
  SectionViewData? _topItem;

  SectionViewAlphabetList<T> get ownWidget {
    return widget as SectionViewAlphabetList<T>;
  }

  set topItem(SectionViewData? val) {
    if (_topItem != val) {
      try {
        setState(() {
          _topItem = val;
        });
      } catch (e, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _topItem = val;
          });
        });
      }
    }
  }

  void onDrag(double yPosition) {
    double checkedHeight = 0;
    int? index;

    // To determine which widget is selected add the height of every alphabet item one by one
    // Until the height is in range of the drag position
    // At that point we have determined the index of the header item and trigger the callback with that item
    for (var i = 0; i < ownWidget.headerToIndexMap.length; i++) {
      double itemHeight = itemKeys[i].currentContext?.size?.height ?? 0;
      checkedHeight += itemHeight;
      if (checkedHeight >= yPosition) {
        index = i;
        break;
      }
    }

    if (index != null) {
      ownWidget.onSelect(ownWidget.headerToIndexMap[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    itemKeys.clear();
    if (ownWidget.alphabetBuilder == null) {
      return const SizedBox(
        width: 0,
        height: 0,
      );
    } else {
      List<Widget> alphabetWidgets = [];
      for (var header in ownWidget.headerToIndexMap) {
        final globalKey = GlobalKey();
        var _alphabetWidget = ownWidget.alphabetBuilder!(
            context,
            header.headerData,
            header.headerIndex == _topItem?.headerIndex,
            header.headerIndex);
        alphabetWidgets.add(GestureDetector(
            key: globalKey,
            onTap: () {
              ownWidget.onSelect(header);
            },
            behavior: HitTestBehavior.opaque,
            child: _alphabetWidget));
        itemKeys.add(globalKey);
      }
      return Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          child: Align(
            alignment: ownWidget.alphabetAlign,
            child: Padding(
              padding: ownWidget.alphabetInset,
              child: GestureDetector(
                onVerticalDragDown: (details) =>
                    onDrag(details.localPosition.dy),
                onVerticalDragUpdate: (details) =>
                    onDrag(details.localPosition.dy),
                child: (Column(
                  mainAxisSize: MainAxisSize.min,
                  children: alphabetWidgets,
                )),
              ),
            ),
          ));
    }
  }
}
