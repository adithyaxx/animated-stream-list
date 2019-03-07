abstract class DiffVisitor {
  void visitInsertDiff(InsertDiff diff);

  void visitDeleteDiff(DeleteDiff diff);

  void visitChangeDiff(ChangeDiff diff);
}

abstract class Diff implements Comparable<Diff> {
  final int index;
  final int size;

  const Diff(this.index, this.size);

  @override
  String toString() {
    return "${this.runtimeType.toString()} index: $index, size: $size";
  }

  @override
  int compareTo(Diff other) => index - other.index;

  void accept(DiffVisitor visitor);
}

class InsertDiff<E> extends Diff {
  final List<E> items;

  InsertDiff(int index, int size, this.items) : super(index, size);

  @override
  void accept(DiffVisitor visitor) => visitor.visitInsertDiff(this);
}

class DeleteDiff extends Diff {
  DeleteDiff(int index, int size) : super(index, size);

  @override
  void accept(DiffVisitor visitor) => visitor.visitDeleteDiff(this);
}

class ChangeDiff<E> extends Diff {
  final List<E> items;

  ChangeDiff(int index, int size, this.items) : super(index, size);

  @override
  void accept(DiffVisitor visitor) => visitor.visitChangeDiff(this);
}
