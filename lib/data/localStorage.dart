// ignore_for_file: file_names

import 'package:hive/hive.dart';
import 'package:to_do_app/models/task_model.dart';

abstract class LocalStorage {
  Future<void> addTask({required Task task});
  Future<Task?> getTask({required String id});
  Future<List<Task>> getAllTask();
  Future<bool> deleteTask({required Task task});
  Future<Task> updateTask({required Task task});
}

//dart add dependency hive indir
//dart add dependency hive_flutter indir
//dart add dev dependency dart_generator indir
//dart add dev dependency build_runner indir
//build runner anotation yapılarına baksın ve bir tane daha model üretsin

class HiveLocalStorage extends LocalStorage {
  late Box<Task> _taskBox;

  HiveLocalStorage() {
    _taskBox = Hive.box<Task>('Tasks');
  }

  @override
  Future<void> addTask({required Task task}) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required Task task}) async {
    await _taskBox.delete(task.id);
    //task.delete();
    return true;
  }

  @override
  Future<List<Task>> getAllTask() async {
    List<Task> allTask = <Task>[];
    allTask = _taskBox.values.toList();

    if (allTask.isNotEmpty) {
      allTask.sort(
        (Task a, Task b) => b.createdAt.compareTo(a.createdAt),
      );
    }
    return allTask;
  }

  @override
  Future<Task?> getTask({required String id}) async {
    if (_taskBox.containsKey(id)) {
      return _taskBox.get(id);
    } else {
      return null;
    }
  }

  @override
  Future<Task> updateTask({required Task task}) async {
    await task.save();
    return task;
  }
}
