import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app_flutter/components/dialogue_box.dart';
import 'package:todo_app_flutter/components/todo_tile.dart';
import 'package:todo_app_flutter/data/dabase.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  // reference the box
  final _myBox = Hive.box('mybox');

  final _textController = TextEditingController();

  // instantiate the external database
  TodoDataBase db = TodoDataBase();

  // create an init state
  @override
  void initState() {
    // if this is the first time ever opening the app,  create a default data
    if (_myBox.get('TODOLIST') == null) {
      // then create an initial data
      db.createinitialData();
      db.updateDataBase();
    } else {
      // the already existing data
      db.loadData();
    }

    super.initState();
  }

  // list of todo
  // List<Map<String, dynamic>> todoList = [
  //   // {"taskName": "Make tutorial", "taskCompleted": false},
  //   // {"taskName": "Make tutorial again", "taskCompleted": true},
  // ];

  // checkbox tap
  void checkboxChanged(bool? value, int index) {
    setState(() {
      db.todoList[index]["taskCompleted"] = value ?? false;
    });
    // update the database whenever the checkbox was changed
    db.updateDataBase();
  }

  void addTask() {
    setState(() {
      db.todoList.add({
        "taskName": _textController.text,
        "taskCompleted": false,
      });
    });
    _textController.clear();
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void addNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogueBox(
          controller: _textController,
          onSave: addTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // delete task
  void deleteTask(int index) {
    setState(() {
      db.todoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text("MY TODOS", style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: db.todoList.isEmpty
          ? Center(
              child: Text(
                "Todo is Empty",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              itemCount: db.todoList.length,
              itemBuilder: (context, index) {
                return TodoTile(
                  taskName: db.todoList[index]["taskName"],
                  taskCompleted: db.todoList[index]["taskCompleted"],
                  onChanged: (value) => checkboxChanged(value, index),
                  deleteFunction: (context) => deleteTask(index),
                );
              },
            ),
      floatingActionButton: SizedBox(
        width: 60.0,
        height: 60.0,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),

          backgroundColor: Colors.black,
          child: Icon(Icons.add, color: Colors.white, size: 50.0),
          onPressed: () {
            addNewTask();
          },
        ),
      ),
    );
  }
}
