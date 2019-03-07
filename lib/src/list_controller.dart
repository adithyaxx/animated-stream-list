import 'package:flutter/material.dart';

typedef Widget AnimatedStreamListItemBuilder<T>(
    T item, BuildContext context, Animation<double> animation);

class ListController<T> {
  final GlobalKey<AnimatedListState> key;
  final List<T> items;
  final Duration duration;
  final AnimatedStreamListItemBuilder<T> itemRemovedBuilder;

  ListController({
    @required this.key,
    @required this.items,
    @required this.itemRemovedBuilder,
    this.duration = const Duration(milliseconds: 300),
  })  : assert(key != null),
        assert(itemRemovedBuilder != null),
        assert(items != null);

  AnimatedListState get _list => key.currentState;

  void insert(int index, T item) {
    items.insert(index, item);

    _list.insertItem(index, duration: duration);
  }

  void removeItemAt(int index) {
    T item = items.removeAt(index);
    _list.removeItem(
        index,
        (BuildContext context, Animation<double> animation) =>
            itemRemovedBuilder(item, context, animation),
        duration: duration);
  }

  int get length => items.length;

  T operator [](int index) => items[index];

  int indexOf(T item) => items.indexOf(item);
}
