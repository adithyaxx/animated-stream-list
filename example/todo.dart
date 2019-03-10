class Todo implements Comparable<Todo> {
  final String title;
  final String content;
  DateTime _changedAt;
  bool _done;

  Todo({this.title, this.content})
      : _changedAt = DateTime.now(),
        _done = false;

  DateTime get changedAt => _changedAt;
  bool get done => _done;

  set done(bool done) {
    _done = done;
    _changedAt = DateTime.now();
  }

  @override
  bool operator ==(other) => other is Todo && other._changedAt == _changedAt;

  @override
  int get hashCode => _changedAt.hashCode;

  @override
  int compareTo(Todo other) =>
      this._changedAt.millisecondsSinceEpoch -
      other._changedAt.millisecondsSinceEpoch;
}
