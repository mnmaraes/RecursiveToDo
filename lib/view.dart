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
  String _strokeStyleCache;
  String _fillStyleCache;
  num _lineWidthCache;
  
  pushContextAttributes(CanvasRenderingContext2D context) {
    _strokeStyleCache = context.strokeStyle;
    _fillStyleCache = context.fillStyle;
    _lineWidthCache = context.lineWidth;
    
    context..strokeStyle = borderColor
           ..lineWidth = borderWidth
           ..fillStyle = backgroundColor
           ..translate(frame.left, frame.top);
  }
  
  popContextAttributes(CanvasRenderingContext2D context) {
    context..strokeStyle = _strokeStyleCache
           ..fillStyle = _fillStyleCache
           ..lineWidth = _lineWidthCache
           ..translate(-frame.left, -frame.top);
  }
  
  //View Methods
  addSubview(View subview) {
    subviews.add(subview);
    subview._superview = this;
  }
  
  //Frame Accessors
  set frame(Rectangle newFrame) => layer._frame = newFrame;
  Rectangle get frame => layer._frame;
  
  //View Accessors
  get superview => _superview;
}

class MouseEventRecognizer {
  View view;
}