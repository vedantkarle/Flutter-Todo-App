import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/todos.dart';
import '../providers/todo.dart';

class TodoItem extends StatefulWidget {
  @override
  _TodoItemState createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    final todos = Provider.of<Todos>(context).todos;
    final todo = Provider.of<Todo>(context);
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(todo.title),
            subtitle: Text(todo.date),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(todos.length * 20.0 + 30, 180),
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          todo.description,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '2 Days Left',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          todo.isCompleted
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                        ),
                        onPressed: () {
                          todo.toggleCompletedStatus();
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
