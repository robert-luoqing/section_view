import 'sectionViewModel.dart';
import 'package:flutter/material.dart';

class SectionViewAlphabetList<T> extends StatefulWidget {
  const SectionViewAlphabetList(
      {required this.headerToIndexMap,
      required this.onTap,
      required this.alphabetAlign,
      required this.alphabetInset,
      this.alphabetBuilder,
      Key? key})
      : super(key: key);
  final SectionViewAlphabetBuilder<T>? alphabetBuilder;
  final List<AlphabetModel<T>> headerToIndexMap;
  final AlphabetItemOnTap<AlphabetModel<T>> onTap;
  final Alignment alphabetAlign;
  final EdgeInsets alphabetInset;

  @override
  SectionViewAlphabetListState<T> createState() =>
      SectionViewAlphabetListState<T>();
}

class SectionViewAlphabetListState<T> extends State<SectionViewAlphabetList> {
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
      } catch (e, s) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          setState(() {
            _topItem = val;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ownWidget.alphabetBuilder == null) {
      return const SizedBox(
        width: 0,
        height: 0,
      );
    } else {
      List<Widget> alphabetWidgets = [];
      for (var header in ownWidget.headerToIndexMap) {
        var _alphabetWidget = ownWidget.alphabetBuilder!(
            context,
            header.headerData,
            header.headerIndex == _topItem?.headerIndex,
            header.headerIndex);
        alphabetWidgets.add(GestureDetector(
            onTap: () {
              ownWidget.onTap(header);
            },
            behavior: HitTestBehavior.opaque,
            child: _alphabetWidget));
      }
      return Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          child: Align(
            alignment: ownWidget.alphabetAlign,
            child: Padding(
              padding: ownWidget.alphabetInset,
              child: (Column(
                mainAxisSize: MainAxisSize.min,
                children: alphabetWidgets,
              )),
            ),
          ));
    }
  }
}
