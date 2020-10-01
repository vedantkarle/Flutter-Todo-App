import 'package:TODO_APP/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/todo.dart';
import '../providers/todos.dart';

class NewTodo extends StatefulWidget {
  static const routeName = '/add-todo';
  @override
  _NewTodoState createState() => _NewTodoState();
}

class _NewTodoState extends State<NewTodo> {
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _todo = Todo(
    id: null,
    title: '',
    description: '',
    date: '',
  );
  var _isLoading = false;
  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    Provider.of<Todos>(context).addTodo(_todo).then((_) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacementNamed('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _todo = Todo(
                          id: _todo.id,
                          title: value,
                          description: _todo.description,
                          date: _todo.date,
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _todo = Todo(
                          id: _todo.id,
                          title: _todo.title,
                          description: value,
                          date: _todo.date,
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Date'),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.datetime,
                      onSaved: (value) {
                        _todo = Todo(
                          id: _todo.id,
                          title: _todo.title,
                          description: _todo.description,
                          date: value,
                        );
                      },
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
