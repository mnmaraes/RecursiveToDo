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
    View view = new View(new Rectangle(30, 30, 500, 500));
    
    view.backgroundColor = "#dddddd";
    view.borderWidth = 2;
    view.clipSubviews = true;
    view.layer.cornerRadius = 10;
    
    subview = new View(new Rectangle(20, 20, 300, 100));
    
    subview.backgroundColor = "#ff0000";
    subview.borderWidth = 1;
    
    label = new Label(new Rectangle(10, 10, 280, 80));

    label.text = "Placeholder Text";
    label.textColor = "#ffffff";
    
    subview.addSubview(label);
    
    view.addSubview(subview);
    
    appWindow.addSubview(view);
    
    appWindow.drawWindow();
    
    MouseOverEventRecognizer recognizer = new MouseOverEventRecognizer(subview, handleStuff);
  }
  
  handleStuff(MouseEventRecognizer recognizer, MouseEvent event) {
    if(recognizer.status == "began"){
      subview.backgroundColor = "#0000ff";
    } else if(recognizer.status == "recognizing"){
      label.text = event.offset.toString();
    } else if(recognizer.status == "ended"){
      subview.backgroundColor = "#ff0000";
    }
    appWindow.drawWindow();
  }
}