part of canvasKit;

class View {
  //Layer
  Layer layer;
  
  //Frame Attributes
  bool clipSubviews = false;
  
  //View Attributes
  String backgroundColor = "#ffffff";
  
  //View Border Attributes
  String borderColor = "#000000";
  num borderWidth = 0;
  
  //Other Views
  View _superview = null;
  List<View> subviews = new List<View>();
  
  //Event Recognizers
  List<EventRecognizer> _eventRecognizers = new List(); 
  
  //Contructors
  View([Rectangle frame]) {
    if(frame != null){
      this.layer = new Layer(frame);
    } else {
      this.layer = new Layer(new Rectangle(0,0,0,0));
    }
  }
  
  
  //View Drawing
  draw(CanvasRenderingContext2D context) {
    //Set Context Properties
    pushContextAttributes(context);
    
    //Draw View
    layer.buildPath(context);
    
    context.fill();
    
    if(borderWidth != 0)
      context.stroke();
    
    if(clipSubviews) {
      context.clip();
    }
    
    drawContents(context);
    
    subviews.forEach((View v) => v.draw(context));
    
    if(borderWidth != 0 && clipSubviews) {
      layer.buildPath(context);
      context.stroke();
    }
    
    popContextAttributes(context);
  }
  drawContents(CanvasRenderingContext2D context){
    //Any Subclass Custom drawing can go here so draw() doesn't need to be overridden.
  }
  
  //Drawing Helper Methods
  pushContextAttributes(CanvasRenderingContext2D context) {
    context..save()
           ..strokeStyle = borderColor
           ..lineWidth = borderWidth
           ..fillStyle = backgroundColor
           ..translate(frame.left, frame.top);
  }
  
  popContextAttributes(CanvasRenderingContext2D context) {
    context.restore();
  }
  
  //View Methods
  addSubview(View subview) {
    subviews.add(subview);
    subview.superview = this;
  }
  
  removeView(View subview) {
    if(subviews.contains(subview))
      subviews.remove(subview);
    
    subview.superview = null;
  }
  
  //Event Recognizer Methods
  addEventRecognizer(EventRecognizer recognizer){
    recognizer.view = this;
  }
  
  reattachRecognizers() {
    _eventRecognizers.forEach((EventRecognizer recognizer) => recognizer.view = this);
    subviews.forEach((View view) => view.reattachRecognizers());
  }
  
  //Frame Accessors
  set frame(Rectangle newFrame) => layer._frame = newFrame;
  Rectangle get frame => layer._frame;
  
  Point get offset {
    num offsetX = frame.left;
    num offsetY = frame.top;
    
    View view = _superview;
    
    while (view != null){
      offsetX += view.frame.left;
      offsetY += view.frame.top;
      
      view = view._superview;
    }
    
    return new Point(offsetX, offsetY);
  }
  
  AppWindow get appWindow {
    View view = this;
    
    while(view != null) {
      if(view is AppWindow)
        return view;
      
      view = view._superview;
    }
    
    return null;
  }
  
  //View Accessors
  View get superview => _superview;
  set superview(View newSuperview) {
    AppWindow oldWindow = appWindow;
    
    _superview = newSuperview;
    
    AppWindow newWindow = appWindow;
    
    if(oldWindow != newWindow && newWindow != null){
      reattachRecognizers();
    }
  }
}