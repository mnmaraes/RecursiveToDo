part of canvasKit;

class AppWindow extends View {
  CanvasElement container;
  
  EventNotificationCenter eventNotificationCenter; 
  
  AppWindow(this.container){
    Rectangle viewFrame = new Rectangle(0, 0, container.client.width, container.client.height);
    this.frame = viewFrame;
    
    eventNotificationCenter = new EventNotificationCenter(this);
  }
  
  drawWindow(){
    container.context2D.clearRect(frame.left, frame.top, frame.width, frame.height);
    draw(container.context2D);
  }
}

class EventNotificationCenter {
  AppWindow appWindow;
  
  Map _events;
  
  EventNotificationCenter(this.appWindow);
}