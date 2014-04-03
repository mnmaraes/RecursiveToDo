part of canvasKit;

typedef void EventHandler(EventRecognizer recognizer, Event event);

abstract class EventRecognizer {
  View _view = null;
  
  String status;
  
  EventHandler handler;
  
  EventRecognizer([View view, this.handler]) {
    this.view = view;
  }
  
  handleEvent(Event event){
    if(shouldRecognizeEvent(event)) {
      handler(this, event);
    }
  }
  
  bool shouldRecognizeEvent(Event event){
    return false;
  }
  
  set view(View newView);
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
    _view = newView;
    _view.appWindow.container.onMouseMove.listen((MouseEvent event) => handleEvent(event));
  }
}