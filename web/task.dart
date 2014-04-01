library task;

class Task {
  String name;
  String details;
  
  Task supertask = null;
  List<Task> subtasks = new List<Task>();
  
  Task(this.name, this.details, {this.supertask}) {
    if(this.supertask != null && !this.supertask.subtasks.contains(this)) {
      this.supertask.subtasks.add(this);  
    }
  }
  
  bool get isRootTaks => supertask == null;
}