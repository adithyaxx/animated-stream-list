abstract class PathNode {
  final int originIndex;
  final int revisedIndex;
  final PathNode previousNode;

  PathNode(this.originIndex, this.revisedIndex, this.previousNode);

  bool isSnake();

  bool isBootStrap() => originIndex < 0 || revisedIndex < 0;

  PathNode previousSnake() {
    if (isBootStrap()) return null;
    if (!isSnake() && previousNode != null) return previousNode.previousSnake();
    return this;
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write("[");
    PathNode node = this;
    while (node != null) {
      buffer.write("(");
      buffer.write("${node.originIndex.toString()}");
      buffer.write(",");
      buffer.write("${node.revisedIndex.toString()}");
      buffer.write(")");
      node = node.previousNode;
    }
    buffer.write("]");
    return buffer.toString();
  }
}

class Snake extends PathNode {
  Snake(int originIndex, int revisedIndex, PathNode previousNode)
      : super(originIndex, revisedIndex, previousNode);

  @override
  bool isSnake() => true;
}

class DiffNode extends PathNode {
  DiffNode(int originIndex, int revisedIndex, PathNode previousNode)
      : super(originIndex, revisedIndex,
            previousNode == null ? null : previousNode.previousSnake());

  @override
  bool isSnake() => false;
}
