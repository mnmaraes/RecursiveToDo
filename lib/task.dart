library task;

class Task{
  String name;
  String details;
  
  Task _supertask = null;
  List<Task> subtasks = new List();
  
  static final Task sharedRoot = new Task._root();
  
  Task(this.name, this.details, [Task supertask]){
    this.supertask = supertask;
  }
  
  Task._root(){
    name = "Master List";
    details = "";
  }
  
  bool get isRootTaks => supertask == null;
  
  Task get supertask => _supertask;
  void set supertask (Task task) {
    if(!task.subtasks.contains(this))
      task.subtasks.add(this);
    
    _supertask = task;
  }
}