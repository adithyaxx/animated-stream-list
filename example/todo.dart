class Todo implements Comparable<Todo> {
  final DateTime changedAt;
  final bool done;
  final String title;
  final String content;

  Todo({this.title, this.content, this.done}) : changedAt = DateTime.now();

  @override
  bool operator ==(other) => other is Todo && other.changedAt == changedAt;

  @override
  int get hashCode => changedAt.hashCode;

  Todo withDone(bool newDone) {
    return Todo(
      title: title,
      content: content,
      done: newDone,
    );
  }

  @override
  int compareTo(Todo other) =>
      this.changedAt.millisecondsSinceEpoch -
      other.changedAt.millisecondsSinceEpoch;
}
