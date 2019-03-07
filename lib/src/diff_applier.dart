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
    for (int i = 0; i < diff.size; i++) {
      _controller.removeItemAt(diff.index);
    }

    int i = 0;
    for (E element in diff.items) {
      _controller.insert(diff.index + i, element);
      i++;
    }
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
