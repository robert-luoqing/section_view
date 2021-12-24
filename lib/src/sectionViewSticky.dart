import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'sectionViewModel.dart';

class SectionViewSticky<T> extends StatefulWidget {
  final List<SectionViewData>? listData;
  final SectionViewHeaderBuilder<T> headerBuilder;

  const SectionViewSticky(
      {required this.headerBuilder, this.listData, Key? key})
      : super(key: key);

  @override
  SectionViewStickyState<T> createState() => SectionViewStickyState<T>();
}

class SectionViewStickyState<T> extends State<SectionViewSticky> {
  /// [_positions] passed by position scroll view and sort by itemTrailingEdge
  List<ItemPosition> _positions = [];

  double _viewportHeight = 0;
  bool _isBounceState = false;

  /// [_currentHeader]用于更新当前的sticky, 如果为null表示没有
  SectionViewData? _currentHeader;

  /// [_strickyPos] will update current sticky position
  double _strickyPos = 0;

  /// [_containerKey] will used to get height of stricky
  final _containerKey = GlobalKey();

  List<SectionViewData> get listData {
    return widget.listData ?? [];
  }

  updateScrollPixed(bool isScrollBounce, double viewportH) {
    _viewportHeight = viewportH;
    _isBounceState = isScrollBounce;
    _mixHandlePosition();
  }

  updateItemPositions(List<ItemPosition> posList) {
    _positions = posList;
    _mixHandlePosition();
  }

  _mixHandlePosition() {
    try {
      SectionViewData? curr;
      double strickyPos = 0;
      if (_isBounceState == false) {
        List<ItemPosition> posList = _positions;
        if (posList.isNotEmpty && listData.length > posList[0].index) {
          var firstItemOfList = listData[posList[0].index];
          if (firstItemOfList.type == SectionViewDataType.dataHeader ||
              firstItemOfList.type == SectionViewDataType.dataItem) {
            curr = firstItemOfList;

            if (_containerKey.currentContext != null) {
              // Get current sticky height
              var stickyHeight = 0.0;
              try {
                stickyHeight = _containerKey.currentContext!.size?.height ?? 0;
              } catch (e, s) {
                // print('--->_mixHandlePosition error $e,$s');
              }

              if (stickyHeight > 0) {
                // Get next header info
                for (var i = 1; i < _positions.length; i++) {
                  var item = _positions[i];
                  var itemData = listData[item.index];
                  if (itemData.itemIndex == null) {
                    var itemLeadingOffset =
                        _viewportHeight * item.itemLeadingEdge;
                    if (itemLeadingOffset < stickyHeight) {
                      // AlphabetHeader _tem = itemData.headerData as AlphabetHeader;
                      // print(
                      //     "------>$itemLeadingOffset, item: ${_tem.alphabet}， _viewportHeight: $_viewportHeight");
                      strickyPos = itemLeadingOffset - stickyHeight;
                    }
                    break;
                  }
                }
              }
            }
          }
        }
      }

      // print("------2>$_viewportHeight");
      if (curr != _currentHeader || strickyPos != _strickyPos) {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          setState(() {
            _currentHeader = curr;
            _strickyPos = strickyPos;
          });
        });
      }
    } catch (ex, ss) {
      // print("=====>$ex, $ss");
    }
  }

  SectionViewSticky<T> get ownWidget {
    return widget as SectionViewSticky<T>;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: _strickyPos,
        left: 0,
        right: 0,
        child: Container(
          key: _containerKey,
          child: _currentHeader != null
              ? ownWidget.headerBuilder(context, _currentHeader!.headerData,
                  _currentHeader!.headerIndex)
              : const SizedBox(
                  height: 0,
                ),
        ));
  }
}
