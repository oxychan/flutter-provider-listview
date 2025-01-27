import 'package:flutter/material.dart';
import 'package:provider_listview/models/task.dart';
import 'package:provider_listview/validation/validation_item.dart';

class Tasklist with ChangeNotifier {
  final List<Task> _taskList = [];
  bool _isActive = true;

  ValidationItem _taskName = ValidationItem(null, null);

  get taskList => _taskList;
  get taskName => _taskName;
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

  void addNewTask(String taskName) {
    _taskList.add(
      Task(
        name: taskName,
        status: false,
      ),
    );
    notifyListeners();
  }
}
