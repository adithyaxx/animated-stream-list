import 'dart:async';

import 'package:animated_stream_list/src/list_controller.dart';
import 'package:animated_stream_list/src/myers_diff.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_stream_list/src/diff_applier.dart';

class AnimatedStreamList<E> extends StatefulWidget {
  final Stream<List<E>> streamList;
  final List<E> initialList;
  final AnimatedStreamListItemBuilder<E> itemBuilder;
  final AnimatedStreamListItemBuilder<E> itemRemovedBuilder;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController scrollController;
  final bool primary;
  final ScrollPhysics scrollPhysics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;
  final Equalizer equals;
  final Duration duration;

  AnimatedStreamList(
      {@required this.streamList,
      this.initialList,
      @required this.itemBuilder,
      @required this.itemRemovedBuilder,
      this.scrollDirection: Axis.vertical,
      this.reverse: false,
      this.scrollController,
      this.primary,
      this.scrollPhysics,
      this.shrinkWrap: false,
      this.padding,
      this.equals,
      this.duration = const Duration(milliseconds: 300)});

  @override
  State<StatefulWidget> createState() => _AnimatedStreamListState<E>();
}

class _AnimatedStreamListState<E> extends State<AnimatedStreamList<E>>
    with WidgetsBindingObserver {
  final GlobalKey<AnimatedListState> _globalKey = GlobalKey();
  ListController<E> _listController;
  DiffApplier<E> _diffApplier;
  DiffUtil<E> _diffUtil;
  StreamSubscription<List<E>> _subscription;

  void startListening() {
    _subscription?.cancel();
    _subscription = widget.streamList.listen((list) async {
      final diffList = await _diffUtil
          .calculateDiff(_listController.items, list, equalizer: widget.equals);
      _diffApplier.applyDiffs(diffList);
    });
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void initState() {
    super.initState();
    _listController = ListController(
        key: _globalKey,
        items: widget.initialList ?? <E>[],
        itemRemovedBuilder: widget.itemRemovedBuilder,
        duration: widget.duration);

    _diffApplier = DiffApplier(_listController);
    _diffUtil = DiffUtil();

    startListening();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        startListening();
        break;
      case AppLifecycleState.paused:
        stopListening();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      initialItemCount: _listController.items.length,
      key: _globalKey,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      primary: widget.primary,
      controller: widget.scrollController,
      physics: widget.scrollPhysics,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      itemBuilder:
          (BuildContext context, int index, Animation<double> animation) =>
              widget.itemBuilder(
        _listController[index],
        index,
        context,
        animation,
      ),
    );
  }
}
