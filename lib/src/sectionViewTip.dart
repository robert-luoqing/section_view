import 'package:flutter/material.dart';

import 'sectionViewModel.dart';
import 'dart:async';

class SectionViewTip<T> extends StatefulWidget {
  const SectionViewTip({this.tipBuilder, Key? key}) : super(key: key);
  final SectionViewTipBuilder<T>? tipBuilder;

  @override
  SectionViewTipState<T> createState() => SectionViewTipState<T>();
}

class SectionViewTipState<T> extends State<SectionViewTip> {
  T? _tipData;
  Timer? _timer;
  bool _showTip = false;

  set tipData(T? val) {
    setState(() {
      _tipData = val;
    });
    if (_tipData != null) {
      _cancelTimerAndSetShowTip(true);
      _timer = Timer(const Duration(milliseconds: 1000), () {
        _cancelTimerAndSetShowTip(false);
      });
    } else {
      _cancelTimerAndSetShowTip(false);
    }
  }

  _cancelTimerAndSetShowTip(bool showTip) {
    setState(() {
      _showTip = showTip;
    });
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  SectionViewTip<T> get ownWidget {
    return widget as SectionViewTip<T>;
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ownWidget.tipBuilder != null && _tipData != null && _showTip) {
      return Positioned(
          child: Center(
        child: Container(child: ownWidget.tipBuilder!(context, _tipData!)),
      ));
    } else {
      return const SizedBox(
        width: 0,
        height: 0,
      );
    }
  }
}
