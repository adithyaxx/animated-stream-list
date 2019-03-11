import 'package:animated_stream_list/src/diff_payload.dart';
import 'package:animated_stream_list/src/list_controller.dart';

class DiffApplier<E> {
  final ListController<E> _controller;
  final DiffVisitor _visitor;

  DiffApplier(this._controller) : _visitor = _Visitor(_controller);

  void applyDiffs(List<Diff> diffs) {
    diffs.forEach((diff) => diff.accept(_visitor));
  }
}

class _Visitor<E> implements DiffVisitor {
  final ListController<E> _controller;

  const _Visitor(this._controller);

  @override
  void visitChangeDiff(ChangeDiff diff) {
    if (diff.size > diff.items.length) {
      int sizeDifference = diff.size - diff.items.length;
      while (sizeDifference > 0) {
        _controller.removeItemAt(diff.index + sizeDifference);
        sizeDifference--;
      }
    } else if (diff.items.length > diff.size) {
      int insertIndex = diff.size;
      while (insertIndex < diff.items.length) {
        _controller.insert(insertIndex + diff.index, diff.items[insertIndex]);
        insertIndex++;
      }
    }

    final changedItems = diff.items.take(diff.size).toList();
    _controller.listChanged(diff.index, changedItems);
  }

  @override
  void visitDeleteDiff(DeleteDiff diff) {
    for (int i = 0; i < diff.size; i++) {
      _controller.removeItemAt(diff.index);
    }
  }

  @override
  void visitInsertDiff(InsertDiff diff) {
    for (int i = 0; i < diff.size; i++) {
      _controller.insert(diff.index + i, diff.items[i]);
    }
  }
}
