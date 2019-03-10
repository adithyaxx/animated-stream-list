import 'dart:math';

import 'package:animated_stream_list/src/myers_diff.dart';
import 'package:benchmark_harness/benchmark_harness.dart';

class TemplateBenchmark extends BenchmarkBase {
  TemplateBenchmark() : super("Template");

  static const size = 1000;

  List<int> l1;
  List<int> l2;

  static void main() {
    new TemplateBenchmark().report();
  }

  void run() async {
    await DiffUtil().calculateDiff(l1, l2);
  }

  void setup() {
    l1 = List.generate(size, (i) => Random().nextInt(1000000));
    l2 = List.from(l1);
    for (int i = 0; i < 200; i++) {
      final index = Random().nextInt(size);
      final value = Random().nextInt(1000000);
      l1[index] = value;
    }
  }

  void teardown() {}
}

main() {
  TemplateBenchmark.main();
}