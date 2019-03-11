import 'package:flutter/material.dart';

typedef Widget AnimatedStreamListItemBuilder<T>(
  T item,
  int index,
  BuildContext context,
  Animation<double> animation,
);

class ListController<E> {
  final GlobalKey<AnimatedListState> key;
  final List<E> items;
  final Duration duration;
  final AnimatedStreamListItemBuilder<E> itemRemovedBuilder;

  ListController({
    @required this.key,
    @required this.items,
    @required this.itemRemovedBuilder,
    this.duration = const Duration(milliseconds: 300),
  })  : assert(key != null),
        assert(itemRemovedBuilder != null),
        assert(items != null);

  AnimatedListState get _list => key.currentState;

  void insert(int index, E item) {
    items.insert(index, item);

    _list.insertItem(index, duration: duration);
  }

  void removeItemAt(int index) {
    E item = items.removeAt(index);
    _list.removeItem(
      index,
      (BuildContext context, Animation<double> animation) =>
          itemRemovedBuilder(item, index, context, animation),
      duration: duration,
    );
  }

  void listChanged(int startIndex, List<E> itemsChanged) {
    int i = 0;
    for (E item in itemsChanged) {
      items[startIndex + i] = item;
      i++;
    }

    // ignore: invalid_use_of_protected_member
    _list.setState(() {});
  }

  int get length => items.length;

  E operator [](int index) => items[index];

  int indexOf(E item) => items.indexOf(item);
}
