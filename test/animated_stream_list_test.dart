import 'package:animated_stream_list/src/myers_diff.dart';
import 'package:quiver/collection.dart';
import 'package:animated_stream_list/src/diff_payload.dart';
import 'package:test/test.dart';

main() {
  test("check if diff works", () {
    final list1 = [1, 2, 3, 4];
    final list2 = [2, 1, 3, 6, 7, 8];
    final diffs = myersDiff(DiffArguments(oldList: list1, newList: list2));

    for (final diff in diffs) {
      _applyDiffTo(list1, diff);
    }

    final areEqual = listsEqual(list1, list2);
    print(areEqual.toString());
    expect(areEqual, true);
  });
}

void _applyDiffTo<T>(List<T> target, Diff diff) {
  if (diff is InsertDiff<T>) {
    for (int i = 0; i < diff.size; i++) {
      target.insert(diff.index + i, diff.items[i]);
    }

    return;
  }

  if (diff is DeleteDiff) {
    for (int i = 0; i < diff.size; i++) {
      target.removeAt(diff.index);
    }

    return;
  }

  if (diff is ChangeDiff<T>) {
    for (int i = 0; i < diff.size; i++) {
      target.removeAt(diff.index);
    }

    int i = 0;
    for (T element in diff.items) {
      target.insert(diff.index + i, element);
      i++;
    }

    return;
  }

  throw Exception();
}
