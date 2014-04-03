part of canvasKit;

class Layer {
  //View Coordinates
  Rectangle _frame = new Rectangle(0, 0, 0, 0);
  
  //Frame Attributes
  Rectangle _outerFrameCache;
  
  //View Border Attributes
  num cornerRadius = 0;
  
  //Constructor
  Layer(this._frame);
  
  //Layer Drawing Methods
  buildPath(CanvasRenderingContext2D context) {
    //Calculate Control Points
    List<Point> p = controlPoints;
    
    context..beginPath()
           ..moveTo(p[0].x, p[0].y);
           
    for(int i = 1; i <= 8; i += 2) {
      context..lineTo(p[i].x, p[i].y)
             ..arcTo(p[i+1].x, p[i+1].y, p[(i+2)].x, p[(i+2)].y, cornerRadius);
    }
  }
  
  //Frame Math Helpers
  List<Point> calculateControlPoints() {
    List<Point> points = new List<Point>(10);
        
    points[0] = new Point(cornerRadius,                0);
    points[1] = new Point(_frame.width - cornerRadius, 0);
    points[2] = new Point(_frame.width,                0);
    points[3] = new Point(_frame.width,                _frame.height - cornerRadius);
    points[4] = new Point(_frame.width,                _frame.height);
    points[5] = new Point(cornerRadius,                _frame.height);
    points[6] = new Point(0,                           _frame.height);
    points[7] = new Point(0,                           cornerRadius);
    points[8] = new Point(0,                           0);
    points[9] = points[0];
    
    return points;
  }
  
  //Frame Accessors
  List<Point> get controlPoints {
    return calculateControlPoints();
  }
}