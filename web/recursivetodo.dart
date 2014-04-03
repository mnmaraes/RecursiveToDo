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
  
  Application(CanvasElement container){
    appWindow = new AppWindow(container); 
  }
  
  start() {
    View view = new View(new Rectangle(30, 30, 500, 500));
    
    view.backgroundColor = "#dddddd";
    view.borderWidth = 2;
    view.layer.cornerRadius = 10;
    
    View subview = new View(new Rectangle(20, 20, 100, 100));
    
    subview.backgroundColor = "#ff0000";
    subview.layer.cornerRadius = 50;
    subview.borderWidth = 1;
    
    view.addSubview(subview);
    
    appWindow.addSubview(view);
    
    appWindow.drawWindow();
    
    appWindow.container.onMouseMove.listen((MouseEvent event){
      CanvasRenderingContext2D context = appWindow.container.context2D;
      
      context.translate(50, 50);
      subview.layer.buildPath(context);
      
      if(context.isPointInPath(event.offset.x, event.offset.y)){
        context.translate(-50, -50);
        subview.backgroundColor = "#0000ff";
        appWindow.drawWindow();
      } else {
        context.translate(-50, -50);
        subview.backgroundColor = "#ff0000";
        appWindow.drawWindow();
      }
      
      context..fillStyle = "#000000"
             ..fillText(event.offset.toString(), 550, 30, 700);
      
    });
  }      
}