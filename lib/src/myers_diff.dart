import 'package:animated_stream_list/src/diff_payload.dart';
import 'package:animated_stream_list/src/path_node.dart';
import 'package:flutter/foundation.dart';

typedef bool Equalizer(dynamic item1, dynamic item2);

class DiffUtil<E> {
  static Equalizer eq;

  Future<List<Diff>> calculateDiff(List<E> oldList, List<E> newList,
      {Equalizer equalizer}) {
    eq = equalizer;
    final args = _DiffArguments<E>(oldList, newList);
    return compute(_myersDiff, args);
  }
}

class _DiffArguments<E> {
  final List<E> oldList;
  final List<E> newList;

  _DiffArguments(this.oldList, this.newList);
}

List<Diff> _myersDiff<E>(_DiffArguments<E> args) {
  final List<E> oldList = args.oldList;
  final List<E> newList = args.newList;

  if (oldList == null) throw ArgumentError("oldList is null");
  if (newList == null) throw ArgumentError("newList is null");

  if (oldList == newList) return [];

  final oldSize = oldList.length;
  final newSize = newList.length;

  if (oldSize == 0) {
    return [InsertDiff(0, newSize, newList)];
  }

  if (newSize == 0) {
    return [DeleteDiff(0, oldSize)];
  }

  final equals = DiffUtil.eq != null ? DiffUtil.eq : (a, b) => a == b;
  final path = _buildPath(oldList, newList, equals);
  final diffs = _buildPatch(path, oldList, newList)..sort();
  return diffs.reversed.toList(growable: true);
}

PathNode _buildPath<E>(List<E> oldList, List<E> newList, Equalizer equals) {
  final oldSize = oldList.length;
  final newSize = newList.length;

  final int max = oldSize + newSize + 1;
  final size = (2 * max) + 1;
  final int middle = size ~/ 2;
  final List<PathNode> diagonal = List(size);

  diagonal[middle + 1] = Snake(0, -1, null);
  for (int d = 0; d < max; d++) {
    for (int k = -d; k <= d; k += 2) {
      final int kmiddle = middle + k;
      final int kplus = kmiddle + 1;
      final int kminus = kmiddle - 1;
      PathNode prev;

      int i;
      if ((k == -d) ||
          (k != d &&
              diagonal[kminus].originIndex < diagonal[kplus].originIndex)) {
        i = diagonal[kplus].originIndex;
        prev = diagonal[kplus];
      } else {
        i = diagonal[kminus].originIndex + 1;
        prev = diagonal[kminus];
      }

      diagonal[kminus] = null;

      int j = i - k;

      PathNode node = DiffNode(i, j, prev);

      while (i < oldSize && j < newSize && equals(oldList[i], newList[j])) {
        i++;
        j++;
      }
      if (i > node.originIndex) {
        node = Snake(i, j, node);
      }

      diagonal[kmiddle] = node;

      if (i >= oldSize && j >= newSize) {
        return diagonal[kmiddle];
      }
    }
    diagonal[middle + d - 1] = null;
  }

  throw Exception();
}

List<Diff> _buildPatch<E>(PathNode path, List<E> oldList, List<E> newList) {
  if (path == null) throw ArgumentError("path is null");

  final List<Diff> diffs = List();
  if (path.isSnake()) {
    path = path.previousNode;
  }
  while (path != null &&
      path.previousNode != null &&
      path.previousNode.revisedIndex >= 0) {
    if (path.isSnake()) throw Exception();
    int i = path.originIndex;
    int j = path.revisedIndex;

    path = path.previousNode;
    int iAnchor = path.originIndex;
    int jAnchor = path.revisedIndex;

    List<E> original = oldList.sublist(iAnchor, i);
    List<E> revised = newList.sublist(jAnchor, j);

    if (original.length == 0 && revised.length != 0) {
      diffs.add(InsertDiff(iAnchor, revised.length, revised));
    } else if (original.length > 0 && revised.length == 0) {
      diffs.add(DeleteDiff(iAnchor, original.length));
    } else {
      diffs.add(ChangeDiff(iAnchor, original.length, revised));
    }

    if (path.isSnake()) {
      path = path.previousNode;
    }
  }

  return diffs;
}
