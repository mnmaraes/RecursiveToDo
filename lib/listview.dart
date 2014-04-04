part of canvasKit;


class ListView extends View {
  ListViewAdapter _adapter;
  
  //View Overridden Default Values
  bool clipSubviews = true;
  
  //Element Views
  List<View> elementViews;
  
  //Constructor
  ListView([Rectangle frame, ListViewAdapter listViewAdapter]) : super(frame) {
    this.adapter = listViewAdapter;
  }
  
  //View Drawing
  drawContents(CanvasRenderingContext2D context){
    elementViews = adapter.prepareElementViews();
    
    elementViews.forEach((View v) => v.draw(context));
  }
  
  set adapter(ListViewAdapter newAdapter){
    if(_adapter != null)
      _adapter.view = null;
    
    if(newAdapter != null)
      newAdapter.view = this;
    
    _adapter = newAdapter; 
  }
  ListViewAdapter get adapter => _adapter;
}

class ListViewAdapter {
  List elements;
  ListView view;
  
  ListViewAdapter([this.elements]);
  
  List<View> prepareElementViews(){
    List<View> views = new List();
    
    num yOffset = 0;
    for(int i = 0; i < elementCount; i++) { // Could probably be a foreach loop.
      var element = elements[i];
      
      num height = heightForElement(element);
      
      Rectangle frame = new Rectangle(0, yOffset, view.frame.width, height);
      
      View elementView = viewForElement(element, frame);
      
      views.add(elementView);
      
      yOffset += height;
    }
    
    return views;
  }
  
  //Methods for Adapting Elements to Views
  View viewForElement(element, Rectangle frame) {
    Label label = new Label(frame);
    
    label.text = element.toString();
    label.borderColor = "#000000";
    label.borderWidth = 1;
    
    return label;
  }
  
  num heightForElement(element){
    return 40;
  }
  
  num get elementCount => elements.length;
}