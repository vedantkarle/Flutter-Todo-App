import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Todo with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String date;
  bool isCompleted;

  Todo({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.date,
    this.isCompleted = false,
  });

  Future<void> toggleCompletedStatus() async {
    final oldStatus = isCompleted;
    isCompleted = !isCompleted;
    notifyListeners();
    final url = 'https://flutter-todo-app-44936.firebaseio.com/todos/$id.json';
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {
            'isCompleted': isCompleted,
          },
        ),
      );
      if (response.statusCode >= 400) {
        isCompleted = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      isCompleted = oldStatus;
      notifyListeners();
    }
  }
}
