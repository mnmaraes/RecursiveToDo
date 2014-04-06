part of canvasKit;

typedef void EventHandler(EventRecognizer recognizer);

abstract class EventRecognizer {
  View _view = null;
  
  String status;
  
  EventHandler handler;
  
  EventRecognizer([View view, this.handler]) {
    this.view = view;
  }
  
  handleEvent(Event event){
    if(shouldRecognizeEvent(event)) {
      handler(this);
    }
  }
  
  bool shouldRecognizeEvent(Event event){
    return false;
  }
  
  set view(View newView) {
    if(!newView._eventRecognizers.contains(this))
      newView._eventRecognizers.add(this);
    
    _view = newView;
  }
  View get view => _view;
}

abstract class MouseEventRecognizer extends EventRecognizer {
  MouseEventRecognizer([View view, EventHandler handler]) : super(view, handler);
  
  bool shouldRecognizeEvent(MouseEvent event){
    Point offset = view.offset;
    
    CanvasRenderingContext2D context = view.appWindow.container.context2D;
    
    context.translate(offset.x, offset.y);
    view.layer.buildPath(context);
    bool shouldRecognize = context.isPointInPath(event.offset.x, event.offset.y);
    context.translate(-offset.x, -offset.y);
    
    return shouldRecognize;
  }
}

//MouseOverEvent has 3 possible states:
//  -"began" once the event began being recognized
//  -"recognizing" state between began and ended 
//  -"ended" called just after the event has stopped being recognized.
class MouseOverEventRecognizer extends MouseEventRecognizer {
  
  MouseOverEventRecognizer([View view, EventHandler handler]) : super(view, handler);
  
  bool shouldRecognizeEvent(MouseEvent event){
    bool superHasRecognized = super.shouldRecognizeEvent(event);
    
    if(superHasRecognized && (status == null || status == "ended")) {
      status = "began";
      return true;
    } else if(superHasRecognized && status  == "began" ) { 
      status = "recognizing";
      return true;
    } else if(!superHasRecognized && (status == "began" || status == "recognizing")){
      status = "ended";
      return true;
    }
    
    return superHasRecognized;
  }
  
  set view(View newView) {
    super.view = newView;
    
    AppWindow appWindow = _view.appWindow;
    
    if(appWindow != null){
      appWindow.container.onMouseMove.listen((MouseEvent event) => handleEvent(event));
    }
  }
}

class MouseClickEventRecognizer extends MouseEventRecognizer {
  MouseClickEventRecognizer([View view, EventHandler handler]) : super(view, handler);
  
  set view(View newView){
    super.view = newView;
        
    AppWindow appWindow = _view.appWindow;
    
    if(appWindow != null){
      appWindow.container.onClick.listen((MouseEvent event) => handleEvent(event));
    }
  }
}