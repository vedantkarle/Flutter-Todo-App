import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'todo.dart';

class Todos with ChangeNotifier {
  List<Todo> _todos = [
    // Todo(
    //   id: '1',
    //   title: 'Todo',
    //   description: 'First Todo',
    //   date: DateTime.now(),
    // ),
    // Todo(
    //   id: '2',
    //   title: 'Todo',
    //   description: 'Second Todo',
    //   date: DateTime.now(),
    // )
  ];
  List<Todo> get todos {
    return [..._todos];
  }

  List<Todo> get completedTodos {
    return _todos.where((todo) => todo.isCompleted).toList();
  }

  Future<void> fetchAndSetTodos() async {
    const url = 'https://flutter-todo-app-44936.firebaseio.com/todos.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Todo> loadedTodos = [];
      extractedData.forEach(
        (todoId, todoData) {
          loadedTodos.add(
            Todo(
              id: todoId,
              title: todoData['title'],
              description: todoData['description'],
              date: todoData['date'],
              isCompleted: todoData['isCompleted'],
            ),
          );
        },
      );
      _todos = loadedTodos;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addTodo(Todo todo) async {
    const url = 'https://flutter-todo-app-44936.firebaseio.com/todos.json';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': todo.title,
            'description': todo.description,
            'date': todo.date,
            'isCompleted': todo.isCompleted,
          },
        ),
      );
      final newTodo = Todo(
        id: json.decode(response.body)['name'],
        title: todo.title,
        description: todo.description,
        date: todo.date,
      );
      _todos.insert(0, newTodo);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  void removeTodo(String todoId) {
    _todos.remove(todoId);
    notifyListeners();
  }
}
