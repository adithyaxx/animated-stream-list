import 'package:animated_stream_list/src/diff_applier.dart';
import 'package:animated_stream_list/src/list_controller.dart';
import 'package:animated_stream_list/src/myers_diff.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:quiver/collection.dart';
import 'package:test/test.dart';

main() {
  test("check if diff works", () async {
    final list1 = [1, 2, 3, 4];
    final list2 = [2, 1, 3, 6, 7, 8];
    final controller = ListController<int>(
      items: list1,
      key: MockKey(),
      itemRemovedBuilder: (int element, int index, BuildContext context,
              Animation<double> animation) =>
          null,
    );

    final diffs = await DiffUtil<int>().calculateDiff(controller.items, list2);
    print (diffs.join(", "));
    DiffApplier(controller).applyDiffs(diffs);

    print("list1: ${controller.items.join(", ")}");
    print("list2: ${list2.join(", ")}");
    final areEqual = listsEqual(controller.items, list2);
    expect(areEqual, true);
  });
}

class MockKey extends Mock implements GlobalKey<AnimatedListState> {
  @override
  AnimatedListState get currentState => MockList();
}

class MockList extends Mock implements AnimatedListState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return super.toString();
  }
}
