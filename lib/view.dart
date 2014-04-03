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
  
  //Contructors
  View([Rectangle frame]) {
    if(frame != null){
      this.layer = new Layer(frame);
    } else {
      this.layer = new Layer(new Rectangle(0,0,0,0));
    }
  }
  
  
  //View Events
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
    
    subviews.forEach((View v) => v.draw(context));
    
    if(borderWidth != 0 && clipSubviews) {
      layer.buildPath(context);
      context.stroke();
    }
    
    popContextAttributes(context);
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
    subview._superview = this;
  }
  
  addEventRecognizer(EventRecognizer recognizer){
    recognizer.view = this;
  }
  
  //TODO: Remove Methods
  
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
  get superview => _superview;
}