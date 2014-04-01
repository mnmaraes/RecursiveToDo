library task;

import 'package:polymer/polymer.dart';

class Task {
  @observable String name;
  @observable String details;
  
  Task supertask = null;
  @observable List<Task> subtasks = toObservable([]);
  
  Task(this.name, this.details, [this.supertask]) {
    if(this.supertask != null && !this.supertask.subtasks.contains(this)) {
      this.supertask.subtasks.add(this);  
    }
  }
  
  bool get isRootTaks => supertask == null;
}