class Result
{
  ArrayList xPos, yPos, p1x, p1y, p2x, p2y;
  Result()
  {
    xPos = new ArrayList();
    xPos = new ArrayList();
  }
  
  void draw(ArrayList _xPos, ArrayList _yPos, ArrayList _p1x, ArrayList _p1y, ArrayList _p2x, ArrayList _p2y)
  {
    
    xPos = _xPos;
    yPos = _yPos;
    p1x = _p1x;
    p1y = _p1y;
    p2x = _p2x;
    p2y = _p2y;
    
     //  background
    fill(180);
    rectMode(CORNER);
    noStroke();
    rect(offset,0,offset,height);
    
    // draw coordinates only as a result from the tiles
    
    for (int i=0; i< xPos.size(); i++)
    {
      int tmpx = (Integer)xPos.get(i);
      int tmpy = (Integer)yPos.get(i);
      
      noFill();
      stroke(100,255,200);
      ellipseMode(CENTER);
      ellipse(tmpx + offset, tmpy, 5, 5);
      
      float tp1x = (Float)p1x.get(i);
      float tp1y = (Float)p1y.get(i);
      float tp2x = (Float)p2x.get(i);
      float tp2y = (Float)p2y.get(i);
      
      ellipseMode(CENTER);
      noStroke();
      fill(10,10,10,100);
      ellipse(tp1x, tp1y, 10, 10);
      ellipse(tp2x, tp2y, 10, 10);
      
    }
  }
  
  void drawLines(ArrayList pX, ArrayList pY) 
  {
    // draw lines between points and shows the midpoint + distances
    for (int i=0; i < pX.size(); i++) 
    {
      for (int j=0; j < pX.size(); j++) 
      {
        if (i != j) {
          float x1 = (Float)pX.get(i);
          float x2 = (Float)pX.get(j);
          
          float y1 = (Float)pY.get(i);
          float y2 = (Float)pY.get(j);
          
          
          stroke(0, 111, 255,100);
          line(x1, y1, x2, y2);
        }
      }
    }
}
}
