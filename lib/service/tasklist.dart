import 'package:flutter/material.dart';

import '../models/task.dart';
import '../validation/validation_item.dart';
import 'database_service.dart';

class Tasklist with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  List<Task> _taskList = [];

  get taskList => _taskList;
  get taskName => _taskName;

  bool _isActive = true;

  ValidationItem _taskName = ValidationItem(null, null);

  get isActive => _isActive;

  // validation
  void setTaskName(String? taskName) {
    // validate if input null
    if (taskName == "") {
      _taskName = ValidationItem(null, "Task Name harus diisi");
      _isActive = false;
    } else if (taskName!.length <= 5) {
      // validate if input less than 5 char
      _taskName = ValidationItem(null, "Task Name harus lebih dari 5 karakter");
      _isActive = false;
    } else {
      // if input is correct
      _taskName = ValidationItem(taskName, null);
    }

    notifyListeners();
  }

  void onTaskNameChange(String? value) {
    if (value != "" && value!.length > 5) {
      _isActive = true;
    }
    clear();

    notifyListeners();
  }

  void clear() {
    _taskName = ValidationItem(null, null);
  }

  bool isValidated() {
    return (_taskName.value != null && _taskName.value!.length >= 5)
        ? true
        : false;
  }

  // void changeTaskName(String taskName) {
  //   _taskName = taskName;
  //   notifyListeners();
  // }

  Future<void> fetchTaskList() async {
    _taskList = await _databaseService.taskList();
    notifyListeners();
  }

  Future<void> addTask() async {
    await _databaseService.insertTask(
      Task(name: _taskName.value, status: 0),
    );
    notifyListeners();
  }

  Future<void> updateTask(Task task, String newVal) async {
    await _databaseService.update(task, newVal);
    await fetchTaskList();
    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    await _databaseService.delete(task);
    notifyListeners();
  }
}
