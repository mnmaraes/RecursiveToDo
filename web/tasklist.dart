import 'task.dart';

import 'package:polymer/polymer.dart';

@CustomTag('task-list')
class TaskList extends PolymerElement {
  
  @published Task task = null;
  
  TaskList.created() : super.created() {
    if(task == null) {
      task = new Task("Master", "Detail");
    }
  }
  
  newTask(){
    new Task("Child", "Detail", task);
  }
}