import '../lib/task.dart';
import '../lib/canvasKit.dart';

void main() {
  Rectangle rect = querySelector("html").client;
  
  DivElement mainDiv = querySelector("#main-div");
  
  num canvasWidth = rect.width * .99;
  num canvasHeight = rect.height * .99;
  
  CanvasElement canvas = new CanvasElement(width: canvasWidth.toInt(), height: canvasHeight.toInt());
  
  mainDiv.children.add(canvas);
  
  Application app = new Application(canvas);
  app.start();
}

class Application {
  AppWindow appWindow;
  
  View subview;
  Label label;
  
  Application(CanvasElement container){
    appWindow = new AppWindow(container);
  }
  
  start() {
    Task masterTask = Task.sharedRoot;
    
    Task subtask = new Task("Programming", "", masterTask);
    
    subtask.addSubtask(new Task("Journey", ""));
    Task subsubtask = new Task("Recursive To Do", "", subtask);
    
    subsubtask.addSubtask(new Task("Some Other Stuff", ""));
    
    subtask = new Task("Writting", "", masterTask);
    
    subtask.addSubtask(new Task("Captain Sky", ""));
    
    masterTask.addSubtask(new Task("Networking", ""));
    
    TaskView taskView = new TaskView(masterTask, new Rectangle(10, 10, 750, 900));
    
    appWindow.addSubview(taskView);
    appWindow.drawWindow();
  }
}

class TaskView extends View {
  //Subviews
  Label label;
  ListView subtasks;
  
  //Attributes
  Task task;
  
  bool isCollapsed = false;
  bool hasSubTasks;
  num level;
  
  //Constructor
  TaskView(this.task, [Rectangle frame, this.level]) : super(frame) {
    if(this.level == null){
      this.level = 0;
    }
    
    buildSubviews();
  }
  
  buildSubviews(){
    buildLabel();
    buildSubtasks();
  }
  
  buildLabel(){
    label = new Label(new Rectangle(0, 0, this.frame.width, 40));
    label.text = task.name;
    
    new MouseOverEventRecognizer(label, onMouseOver);
    new MouseClickEventRecognizer(label, onMouseClick); 
    
    this.addSubview(label);
  }
  
  buildSubtasks(){
    if(task.subtasks.length > 0){
      TaskListViewAdapter adapter = new TaskListViewAdapter(task.subtasks);
    
      num identLevel = this.frame.width * .02;
    
      subtasks = new ListView(new Rectangle(identLevel, 40, this.frame.width - identLevel, this.frame.height - 40), adapter);
    
      this.addSubview(subtasks);
    }
  }
  
  //View Events
  updateSubviews(){
    //TODO : Update Subviews to occupy new frame's space 
  }
  
  onMouseOver(MouseOverEventRecognizer recognizer){
    if(recognizer.status == "began"){
      label.font = "bold 20px HelveticaNeue, Helvetica, sans-serif";
    } else if(recognizer.status == "ended") {
      label.font = "20px HelveticaNeue, Helvetica, sans-serif";
    }
    appWindow.drawWindow();
  }
  
  onMouseClick(MouseClickEventRecognizer recognizer){
    //TODO : Handle Click Events
  }
  
  
  //Overridden Accessors
  set frame(Rectangle newFrame){
    super.frame = newFrame;
    updateSubviews();
  }
}

class TaskListViewAdapter extends ListViewAdapter{
  TaskListViewAdapter([List elements]) : super(elements);
  
  //Methods for Adapting Elements to Views - Overridden
  View viewForElement(element, Rectangle frame){
    return new TaskView(element, frame);
  }
  
  num heightForElement(element){
    return ((element as Task).numberOfSubtasks + 1)* 40;
  }
}