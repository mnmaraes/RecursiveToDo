part of canvasKit;


class Label extends View{
  //Text Attributes
  String text;
  String font = "20px HelveticaNeue-Light, HelveticaNeue, Helvetica, sans-serif";
  String textColor = "#000000";
  
  //View Overridden Default Attributes
  String backgroundColor = null;
  
  //Constructors
  Label([Rectangle frame]) : super(frame);
  
  //View Drawing
  drawContents(CanvasRenderingContext2D context) {
    context..fillStyle = textColor
           ..font = font
           ..fillText(text, frame.left, (frame.height)/2, frame.width);
  }
}