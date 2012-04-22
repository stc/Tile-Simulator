boolean tileDragged = false; // a tile is dragged already

class Tile
{
  int x,y,r, ID; 
  float angle, targetAnglex, targetAngley, ex, ey = 0;
  float easing = 0.02;
  
  boolean drag;
  boolean rotating = false;
  
  //  point positions for the markers (define distance)
  float p1x, p1y, p2x, p2y;
  
  //  absolute position of the markers (avoid matrix transformations to get coordinates)
  float point1x, point1y, point2x, point2y;
  
  Tile(int _x,int _y, int _r, float _a, int _ID)
  {
      x = _x; 
      y = _y; 
      r = _r; 
      angle = _a;
      ID = _ID;
  }
      
  void draw()
  {
   pushMatrix();
      translate(x,y);
      rotate(angle);
      translate(-x,-y);
      rectMode(CENTER);
      noFill();
      stroke(255,200);
      //  draw tile edges
      rect(x, y, r, r);
   popMatrix();
      //  draw points to the surface 
      ellipseMode(CENTER);
      stroke(255,0,0,200);

   //  check which ID of the tile we have, select
   //  pattern according to ID
   checkID();  
       
      point1x = x + cos(angle  + radians(45)) * p1x;
      point1y = y + sin(angle  + radians(45)) * p1y;
      ellipse(point1x,point1y,10,10);
      
      point2x = x + cos(angle + radians(45)) * p2x;
      point2y = y + sin(angle + radians(45)) * p2y;
      ellipse(point2x,point2y,10,10);
  
   //  check events
   checkDragging();
   checkRotating();
  }
  
  void checkDragging()
  {
      if (mouseX >= x-r/2 && mouseX <= x+r/2 && mouseY >= y-r/2 && mouseY <= y+r/2 && mousePressed && (mouseButton == LEFT)
        && !tileDragged)
      {
        tileDragged = true;
        drag = true;
      }
      
      if (drag)
      {
          if (!mousePressed)
          {
            drag = false;
            tileDragged = false;
          }            
          moveTile();
      }
  }

  void checkRotating()
  {
      if(mouseX >= x-r/2 && mouseX <= x+r/2 && mouseY >= y-r/2 && mouseY <= y+r/2 && mousePressed && (mouseButton == RIGHT))
      {
        rotating = true;
      }
      else
      {
        rotating = false;
      }
      if(mouseX >= x-r/2 && mouseX <= x+r/2 && mouseY >= y-r/2 && mouseY <= y+r/2 && !mousePressed)
      {
        rotating = false;
      }
     
      if(rotating) 
      {
          rotateTile();
      }
  }
  
  void checkID()
  {
    if(ID == 1)
    {
       p1x = -r/2.58;
       p1y = -r/2.58;
       p2x = r/2.58;
       p2y = r/2.58; 
    }
    
    if(ID == 2)
    {
       p1x = -r/2.95;
       p1y = -r/2.95;
       p2x = r/2.95;
       p2y = r/2.95; 
    }
    
    if(ID == 3)
    {
       p1x = -r/3.26;
       p1y = -r/3.26;
       p2x = r/3.26;
       p2y = r/3.26; 
    }
    
    if(ID == 4)
    {
       p1x = -r/3.87;
       p1y = -r/3.87;
       p2x = r/3.87;
       p2y = r/3.87; 
    }
    
    if(ID == 5)
    {
       p1x = -r/4.76;
       p1y = -r/4.76;
       p2x = r/4.76;
       p2y = r/4.76; 
    }
    
    if(ID == 6)
    {
       p1x = -r/6.2;
       p1y = -r/6.2;
       p2x = r/6.2;
       p2y = r/6.2; 
    }
  }
  
  void moveTile()  
  {  
    x=mouseX; y=mouseY; 
  }
  
  void rotateTile()  
  {
   targetAnglex = mouseX-x;
   targetAngley = mouseY-y;
   float dx = targetAnglex - ex;  if(abs(dx)>1){ex += dx * easing;} 
   float dy = targetAngley- ey;  if(abs(dy)>1){ey += dy * easing;} 
   angle = atan2(ey,ex);   
  }
}
