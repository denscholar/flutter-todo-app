import 'package:hive/hive.dart';

class TodoDataBase {
  List<Map<String, dynamic>> todoList = [];

  // reference the box
  final _mybox = Hive.box('mybox');

  // create the initial data to be used the first time opening the app
  void createinitialData() {
    todoList = [
      {"taskName": "Make tutorial", "taskCompleted": false},
      {"taskName": "Make tutorial again", "taskCompleted": true},
    ];
  }

  // load the data from the database
  void loadData() {
    final rawData = _mybox.get("TODOLIST") ?? [];
    todoList = List<Map<String, dynamic>>.from(
      rawData.map((item) => Map<String, dynamic>.from(item)),
    );
  }

  // update the databasse in the hive database
  void updateDataBase() {
    _mybox.put("TODOLIST", todoList);
  }
}
