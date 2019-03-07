import 'dart:async';

import 'package:animated_stream_list/src/list_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'myers_diff.dart' as DiffUtil;
import 'package:animated_stream_list/src/diff_applier.dart';

class AnimatedStreamList<E> extends StatefulWidget {
  final Stream<List<E>> streamList;
  final AnimatedStreamListItemBuilder<E> itemBuilder;
  final AnimatedStreamListItemBuilder<E> itemRemovedBuilder;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController scrollController;
  final bool primary;
  final ScrollPhysics scrollPhysics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;
  final DiffUtil.Equalizer<E> equals;

  AnimatedStreamList({
    @required this.streamList,
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
  });

  @override
  State<StatefulWidget> createState() => _AnimatedStreamListState<E>();
}

class _AnimatedStreamListState<E> extends State<AnimatedStreamList<E>> {
  final GlobalKey<AnimatedListState> _globalKey = GlobalKey();
  ListController<E> _listController;
  DiffApplier<E> _diffApplier;

  @override
  void initState() {
    super.initState();
    _listController = ListController(
      key: _globalKey,
      items: <E>[],
      itemRemovedBuilder: widget.itemRemovedBuilder,
    );

    _diffApplier = DiffApplier(_listController);

    widget.streamList.listen((list) async {
      final args = DiffUtil.DiffArguments(
        oldList: _listController.items,
        newList: list,
        equalizer: widget.equals,
      );
      final diffList = await compute(DiffUtil.myersDiff, args);
      _diffApplier.applyDiffs(diffList);
    });
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
              widget.itemBuilder(_listController[index], context, animation),
    );
  }
}
