import 'dart:async';

import 'todo.dart';

class TodoBloc {
  final List<Todo> _todoList = [];

  final StreamController<List<Todo>> _todoListStream = StreamController();
  Stream<List<Todo>> get todoListStream => _todoListStream.stream;

  TodoBloc() {
    _todoListStream.add(_todoList);
  }

  void addTodo(Todo todo) {
    _todoList.add(todo);
    _todoList.sort();
    _todoListStream.add(_todoList);
  }

  void removeTodo(int index) {
    _todoList.removeAt(index);
    _todoListStream.add(_todoList);
  }

  void toggleDone(int index) {
    final todo = _todoList[index];
    todo.done = !todo.done;
    _todoListStream.add(_todoList);
  }

  void dispose() {
    _todoListStream.close();
  }
}
