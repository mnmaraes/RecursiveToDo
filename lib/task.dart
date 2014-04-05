library task;

class Task{
  String name;
  String details;
  
  Task _supertask = null;
  List<Task> subtasks = new List();
  
  static final Task sharedRoot = new Task._root();
  
  //Constructors
  Task(this.name, this.details, [Task supertask]){
    if(supertask != null) {
      this.supertask = supertask;
    }
  }
  
  Task._root(){
    name = "Master List";
    details = "";
  }
  
  //Task Methods
  addSubtask(Task subtask){
    subtask.supertask = this;
  }
  
  //Accessors
  bool get isRootTask => supertask == null;
  
  Task get supertask => _supertask;
  void set supertask (Task task) {
    if(!task.subtasks.contains(this))
      task.subtasks.add(this);
    
    _supertask = task;
  }
  
  num get numberOfSubtasks {
    num count = subtasks.length;
    
    subtasks.forEach((Task task) => count += task.numberOfSubtasks);
    
    return count;
  }
}