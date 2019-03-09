import 'dart:math';

import 'package:animated_stream_list/animated_stream_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'todo.dart';
import 'snackbar_factory.dart';
import 'todos_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TodoBloc _todoBloc;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _todoBloc = TodoBloc(SnackBarFactory());

    _todoBloc.snackBarEvent.listen((snackBar) {
      scaffoldKey.currentState.hideCurrentSnackBar();
      scaffoldKey.currentState.showSnackBar(snackBar);
    });
    super.initState();
  }

  @override
  void dispose() {
    _todoBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text("Animated Stream List example"),
      ),
      body: SafeArea(
        child: _buildStreamList(_todoBloc.todoListStream),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleAddTodoTapped(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _handleAddTodoTapped() {
    final todo = Todo(
      title: _randomString(10),
      content: _randomString(20),
      done: false,
    );

    _todoBloc.addTodo(todo);
  }

  String _randomString(int length) {
    final codeUnits = List.generate(length, (i) => Random().nextInt(33) + 89);

    return String.fromCharCodes(codeUnits);
  }

  Widget _buildStreamList(Stream<List<Todo>> todoListStream) {
    return AnimatedStreamList<Todo>(
      streamList: todoListStream,
      itemBuilder:
          (Todo todo, BuildContext context, Animation<double> animation) =>
          _buildTile(todo, animation),
      itemRemovedBuilder:
          (Todo todo, BuildContext context, Animation<double> animation) =>
          _buildRemovedTile(todo, animation),
    );
  }

  Widget _buildTile(Todo todo, Animation<double> animation) {
    TextStyle textStyle = TextStyle();
    if (todo.done) {
      textStyle = TextStyle(decoration: TextDecoration.lineThrough);
    }

    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: Card(
        child: ListTile(
          leading: Checkbox(
            value: todo.done,
            onChanged: (newValue) => _todoBloc.toggleDone(todo),
          ),
          title: Text(
            todo.title,
            style: textStyle,
          ),
          subtitle: Text(
            todo.content,
            style: textStyle,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _todoBloc.removeTodo(todo),
          ),
        ),
      ),
    );
  }

  Widget _buildRemovedTile(Todo todo, Animation<double> animation) {
    TextStyle textStyle = TextStyle();
    if (todo.done) {
      textStyle = TextStyle(decoration: TextDecoration.lineThrough);
    }

    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: Card(
        child: ListTile(
          leading: Checkbox(
            value: todo.done,
            onChanged: null,
          ),
          title: Text(
            todo.title,
            style: textStyle,
          ),
          subtitle: Text(
            todo.content,
            style: textStyle,
          ),
          trailing: const Icon(Icons.delete),
        ),
      ),
    );
  }
}
