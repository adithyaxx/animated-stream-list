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

  void removeTodo(Todo todo) {
    _todoList.remove(todo);
    _todoList.sort();
    _todoListStream.add(_todoList);
  }

  void toggleDone(Todo todo) {
    final newTodo = todo.withDone(!todo.done);
    final indexOf = _todoList.indexOf(todo);
    _todoList[indexOf] = newTodo;
    _todoListStream.add(_todoList);
  }

  void dispose() {
    _todoListStream.close();
  }
}
