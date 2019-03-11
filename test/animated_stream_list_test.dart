import 'package:animated_stream_list/src/diff_applier.dart';
import 'package:animated_stream_list/src/list_controller.dart';
import 'package:animated_stream_list/src/myers_diff.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:quiver/collection.dart';
import 'package:test/test.dart';

main() {
  test("check if handles bigger list", () async {
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
    DiffApplier(controller).applyDiffs(diffs);

    final areEqual = listsEqual(controller.items, list2);
    expect(areEqual, true);
  });

  test("check if handles smaller list", () async {
    final list1 = [2, 1, 3, 6, 7, 8];
    final list2 = [1, 2, 3, 4];
    final controller = ListController<int>(
      items: list1,
      key: MockKey(),
      itemRemovedBuilder: (int element, int index, BuildContext context,
              Animation<double> animation) =>
          null,
    );

    final diffs = await DiffUtil<int>().calculateDiff(controller.items, list2);
    DiffApplier(controller).applyDiffs(diffs);

    final areEqual = listsEqual(controller.items, list2);
    expect(areEqual, true);
  });

  test("check if handles equal sized lists", () async {
    final list1 = [2, 1, 3, 6, 7, 8];
    final list2 = [1, 2, 3, 4, 0, 8];
    final controller = ListController<int>(
      items: list1,
      key: MockKey(),
      itemRemovedBuilder: (int element, int index, BuildContext context,
                           Animation<double> animation) =>
      null,
    );

    final diffs = await DiffUtil<int>().calculateDiff(controller.items, list2);
    DiffApplier(controller).applyDiffs(diffs);

    final areEqual = listsEqual(controller.items, list2);
    expect(areEqual, true);
  });

  test("check if handles equal lists", () async {
    final list1 = [2, 1, 3, 6, 7, 8];
    final list2 = [2, 1, 3, 6, 7, 8];
    final controller = ListController<int>(
      items: list1,
      key: MockKey(),
      itemRemovedBuilder: (int element, int index, BuildContext context,
                           Animation<double> animation) =>
      null,
    );

    final diffs = await DiffUtil<int>().calculateDiff(controller.items, list2);
    DiffApplier(controller).applyDiffs(diffs);

    final areEqual = listsEqual(controller.items, list2);
    expect(areEqual, true);
  });

  test("check if throws when second list is null", () async {
    final list1 = [1];
    final list2 = null;
    final controller = ListController<int>(
      items: list1,
      key: MockKey(),
      itemRemovedBuilder: (int element, int index, BuildContext context,
              Animation<double> animation) =>
          null,
    );

    final diffs = DiffUtil<int>().calculateDiff(controller.items, list2);
    expect(() async => await diffs, throwsException);
  });

  group("check if handles one list being empty", () {
    test("first list empty", () async {
      final list1 = <int>[];
      final list2 = [1,2,3];
      final controller = ListController<int>(
        items: list1,
        key: MockKey(),
        itemRemovedBuilder: (int element, int index, BuildContext context,
                             Animation<double> animation) =>
        null,
      );

      final diffs = await DiffUtil<int>().calculateDiff(controller.items, list2);
      DiffApplier(controller).applyDiffs(diffs);

      final areEqual = listsEqual(controller.items, list2);
      expect(areEqual, true);
    });

    test("second list empty", () async {
      final list1 = [1,2,3];
      final list2 = <int>[];
      final controller = ListController<int>(
        items: list1,
        key: MockKey(),
        itemRemovedBuilder: (int element, int index, BuildContext context,
                             Animation<double> animation) =>
        null,
      );

      final diffs = await DiffUtil<int>().calculateDiff(controller.items, list2);
      DiffApplier(controller).applyDiffs(diffs);

      final areEqual = listsEqual(controller.items, list2);
      expect(areEqual, true);
    });
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
