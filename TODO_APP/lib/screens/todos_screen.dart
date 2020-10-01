import 'package:TODO_APP/widgets/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todos.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions {
  Completed,
  All,
}

class TodosScreen extends StatefulWidget {
  @override
  _TodosScreenState createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  var _showOnlyCompleted = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Todos>(context).fetchAndSetTodos().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final todosData = Provider.of<Todos>(context);
    final todos =
        _showOnlyCompleted ? todosData.completedTodos : todosData.todos;
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Completed) {
                  _showOnlyCompleted = true;
                } else {
                  _showOnlyCompleted = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Completed Tasks'),
                value: FilterOptions.Completed,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) => ChangeNotifierProvider.value(
                value: todos[index],
                child: TodoItem(),
              ),
              itemCount: todos.length,
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/add-todo');
        },
      ),
    );
  }
}
