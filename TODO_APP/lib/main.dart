import 'package:TODO_APP/widgets/new_todo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/todos.dart';
import './screens/todos_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Todos(),
        ),
      ],
      child: MaterialApp(
        title: 'Todo App',
        home: TodosScreen(),
        routes: {
          NewTodo.routeName: (ctx) => NewTodo(),
        },
      ),
    );
  }
}
