import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'sectionViewModel.dart';
import 'sectionViewBouncingScrollRefresh.dart';
import 'sectionViewAlphabetList.dart';
import 'sectionViewSticky.dart';
import 'sectionViewTip.dart';

class SectionView<T, N> extends StatefulWidget {
  const SectionView(
      {required this.source,
      required this.onFetchListData,
      required this.headerBuilder,
      required this.itemBuilder,
      this.onRefresh,
      this.refreshBuilder,
      this.alphabetAlign = Alignment.center,
      this.alphabetInset = const EdgeInsets.all(4.0),
      this.enableSticky = true,
      this.alphabetBuilder,
      this.tipBuilder,
      this.physics,
      Key? key})
      : super(key: key);

  final List<T> source;
  final SectionViewOnFetchListData<T, N> onFetchListData;
  final SectionViewHeaderBuilder<T> headerBuilder;
  final SectionViewItemBuilder<T, N> itemBuilder;
  final SectionViewAlphabetBuilder<T>? alphabetBuilder;
  final SectionViewTipBuilder<T>? tipBuilder;
  final SectionViewOnRefresh? onRefresh;
  final SectionViewRefreshBuilder? refreshBuilder;
  final bool enableSticky;
  final Alignment alphabetAlign;
  final EdgeInsets alphabetInset;
  final ScrollPhysics? physics;

  @override
  _SectionViewState<T, N> createState() => _SectionViewState<T, N>();
}

class _SectionViewState<T, N> extends State<SectionView> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  /// listData will used to bind [ScrollablePositionedList]
  List<SectionViewData> _listData = [];

  /// Map header to index of [ScrollablePositionedList]
  List<AlphabetModel<T>> _headerToIndexMap = [];

  bool _isRefreshing = false;

  final stickyKey = GlobalKey<SectionViewStickyState>();
  final alphabetTipKey = GlobalKey<SectionViewTipState>();
  final sectionViewAlphabetListKey = GlobalKey<SectionViewAlphabetListState>();

  SectionView<T, N> get ownWidget {
    return widget as SectionView<T, N>;
  }

  Future _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });
    try {
      if (ownWidget.onRefresh != null) {
        await ownWidget.onRefresh!();
      }
    } catch (e, s) {
      // Do nothing
    }
    setState(() {
      _isRefreshing = false;
    });
  }

  _buildList() {
    List<SectionViewData> _buildData = [];
    List<AlphabetModel<T>> _buildMap = [];
    int _headerIndex = 0;
    int _listIndex = 0;
    // Add refresh control on it
    _buildData.add(SectionViewData(
        type: SectionViewDataType.refresh, headerIndex: -1, headerData: null));
    _listIndex++;

    for (T _header in ownWidget.source) {
      _buildData.add(SectionViewData(
          type: SectionViewDataType.dataHeader,
          headerIndex: _headerIndex,
          headerData: _header));

      var _itemIndex = 0;
      _buildMap.add(AlphabetModel(
          mapIndex: _listIndex,
          headerData: _header,
          headerIndex: _headerIndex));

      _listIndex++;

      var _itemList = ownWidget.onFetchListData(_header);
      for (N _item in _itemList) {
        _buildData.add(SectionViewData(
            type: SectionViewDataType.dataItem,
            headerIndex: _headerIndex,
            headerData: _header,
            itemIndex: _itemIndex,
            itemData: _item));
        _itemIndex++;
        _listIndex++;
      }

      _headerIndex++;
    }

    // Add loading control on it
    _buildData.add(SectionViewData(
        type: SectionViewDataType.loading, headerIndex: -1, headerData: null));
    _listIndex++;

    _listData = _buildData;
    _headerToIndexMap = _buildMap;
  }

  void _positionsChanged() {
    Iterable<ItemPosition> positions =
        _itemPositionsListener.itemPositions.value;

    SectionViewData? currentTopItem;
    List<ItemPosition> updatedPosition = [];
    if (positions.isNotEmpty) {
      List<ItemPosition> newPositions = positions
          .where((ItemPosition position) => position.itemTrailingEdge > 0)
          .toList();
      newPositions.sort((a, b) =>
          ((a.itemTrailingEdge - b.itemTrailingEdge) * 1000000).toInt());

      if (newPositions.length > 0) {
        var firstPosition = newPositions.first;

        int index = firstPosition.index;
        var type = _listData[index].type;
        if (type == SectionViewDataType.dataHeader ||
            type == SectionViewDataType.dataItem) {
          currentTopItem = _listData[index];
        }
      }
      updatedPosition = newPositions;
    }

    if (sectionViewAlphabetListKey.currentState != null) {
      sectionViewAlphabetListKey.currentState!.topItem = currentTopItem;
    }
    if (stickyKey.currentState != null) {
      stickyKey.currentState!.updateItemPositions(updatedPosition);
    }
  }

  @override
  void initState() {
    _itemPositionsListener.itemPositions.addListener(_positionsChanged);
    _buildList();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SectionView oldWidget) {
    _buildList();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_positionsChanged);
    super.dispose();
  }

  bool _getPhysicsIsBounce() {
    late ScrollPhysics physics;
    if (ownWidget.physics != null) {
      physics = ownWidget.physics!;
    } else {
      var sc = ScrollConfiguration.of(context);
      physics = sc.getScrollPhysics(context);
    }
    return physics is BouncingScrollPhysics;
  }

  Widget _determineRefereshControl(bool isRefreshing,
      SectionViewOnRefresh onRefresh, bool isBouncePhysic, Widget? child) {
    if (ownWidget.refreshBuilder != null) {
      return ownWidget.refreshBuilder!(
          isRefreshing, onRefresh, isBouncePhysic, child);
    } else {
      if (isBouncePhysic) {
        return SectionViewBouncingScrollRefresh(
          isRefreshing: _isRefreshing,
          onRefresh: _onRefresh,
        );
      } else {
        return RefreshIndicator(
            onRefresh: _onRefresh, child: child ?? Container());
      }
    }
  }

  Widget _renderRefereshControl(bool isBouncePhysic) {
    if (isBouncePhysic) {
      if (ownWidget.onRefresh != null) {
        return _determineRefereshControl(
            _isRefreshing, _onRefresh, isBouncePhysic, null);
      }
    }
    return Container();
  }

  Widget _renderList(bool isBouncePhysic) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        var metrics = notification.metrics;

        if (stickyKey.currentState != null) {
          stickyKey.currentState!.updateScrollPixed(
              metrics.pixels <= metrics.minScrollExtent,
              metrics.viewportDimension);
        }

        return false;
      },
      child: ScrollablePositionedList.builder(
        physics: ownWidget.physics,
        itemCount: _listData.length,
        itemBuilder: (context, index) {
          SectionViewData itemData = _listData[index];
          switch (itemData.type) {
            case SectionViewDataType.dataHeader:
              return ownWidget.headerBuilder(
                  context, itemData.headerData, itemData.headerIndex);
            case SectionViewDataType.dataItem:
              return ownWidget.itemBuilder(
                  context,
                  itemData.itemData,
                  itemData.itemIndex!,
                  itemData.headerData,
                  itemData.headerIndex);
            case SectionViewDataType.refresh:
              return _renderRefereshControl(isBouncePhysic);
            case SectionViewDataType.loading:
              return Container();
          }
        },
        itemScrollController: _itemScrollController,
        itemPositionsListener: _itemPositionsListener,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var isBouncePhysic = _getPhysicsIsBounce();

    Widget content = Container(
        child: Stack(
      children: [
        _renderList(isBouncePhysic),
        ownWidget.enableSticky
            ? SectionViewSticky<T>(
                listData: _listData,
                headerBuilder: ownWidget.headerBuilder,
                key: stickyKey,
              )
            : Container(),
        SectionViewAlphabetList<T>(
          alphabetBuilder: ownWidget.alphabetBuilder,
          headerToIndexMap: _headerToIndexMap,
          alphabetAlign: ownWidget.alphabetAlign,
          alphabetInset: ownWidget.alphabetInset,
          key: sectionViewAlphabetListKey,
          onTap: <T>(item) {
            if (alphabetTipKey.currentState != null) {
              alphabetTipKey.currentState!.tipData = item.headerData;
            }
            _itemScrollController.jumpTo(index: item.mapIndex);
          },
        ),
        SectionViewTip(
          tipBuilder: ownWidget.tipBuilder,
          key: alphabetTipKey,
        )
      ],
    ));

    if (!isBouncePhysic) {
      content = RefreshIndicator(onRefresh: _onRefresh, child: content);
    }

    return content;
  }
}

SectionViewAlphabetBuilder<T> getDefaultAlphabetBuilder<T>(
    String fetchAlphabet(T data)) {
  return (BuildContext context, T headerData, bool isCurrent, int headerIndex) {
    return isCurrent
        ? SizedBox(
            width: 18,
            height: 18,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(9)),
                child: Center(
                    child: Text(
                  fetchAlphabet(headerData),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ))))
        : Text(
            fetchAlphabet(headerData),
            style: TextStyle(color: Color(0xFF767676)),
          );
  };
}

SectionViewTipBuilder<T> getDefaultTipBuilder<T>(String fetchAlphabet(T data)) {
  return (BuildContext context, T headerData) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Color(0xCC000000)),
        width: 50,
        height: 50,
        child: Center(
          child: Text(
            fetchAlphabet(headerData),
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ));
  };
}

SectionViewHeaderBuilder<T> getDefaultHeaderBuilder<T>(
    String fetchAlphabet(T data),
    {Color? bkColor,
    TextStyle? style}) {
  return (BuildContext context, T headerData, int headerIndex) {
    return Container(
      color: bkColor != null ? bkColor : const Color(0xFFF3F4F5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Text(
          fetchAlphabet(headerData),
          style: style != null
              ? style
              : const TextStyle(fontSize: 18, color: Color(0xFF767676)),
        ),
      ),
    );
  };
}
