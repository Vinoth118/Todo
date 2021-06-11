import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum EventType { addTodo, deleteTodo }

class TodoEvent {
  EventType eventType = EventType.addTodo;
  String todo = '';
  int index = 0;

  TodoEvent.add(String todo) {
    this.eventType = EventType.addTodo;
    this.todo = todo;
  }

  TodoEvent.delete(int index) {
    this.eventType = EventType.deleteTodo;
    this.index = index;
  }
}

class TodoBloc extends Bloc<TodoEvent, List> {
  TodoBloc(List todoList) : super(todoList);
  List todoList = [];
  bool validate = false;
  var textController = new TextEditingController();

  newState(String type, int index, String todo) {
    if (type == 'add') {
      this.textController.text.isEmpty ? validate = true : validate = false;
      if (validate == false) {
        todoList.add({'todo': '$todo', 'checked': false});
        textController.clear();
      }
    }
    if (type == 'delete') {
      todoList.removeAt(index);
    }
  }

  @override
  Stream<List> mapEventToState(TodoEvent event) async* {
    switch (event.eventType) {
      case EventType.addTodo:
        newState('add', event.index, event.todo);
        yield todoList;
        break;
      case EventType.deleteTodo:
        newState('delete', event.index, event.todo);
        yield todoList;
        break;
    }
  }
}
