//  original tiles
ArrayList tiles;
int tiletypes = 6;

//  all coordinates --------------------
ArrayList touchPoints;
//--------------------------------------

//  storing positions of tiles
ArrayList tiles_posX;
ArrayList tiles_posY;

//  storing positions of points on the tiles
ArrayList p1posX;
ArrayList p1posY;
ArrayList p2posX;
ArrayList p2posY;

//  tile tracker
Tracker tracker;

int offset;

void setup() 
{
  size(1000, 500);
  background(0); 
  smooth();
  
  offset = width/2;
  
  tiles = new ArrayList();
 
  tiles_posX = new ArrayList();
  tiles_posY = new ArrayList();
  
  p1posX = new ArrayList();
  p1posY = new ArrayList(); 
  p2posX = new ArrayList();
  p2posY = new ArrayList();
  
  touchPoints = new ArrayList();
  tracker = new Tracker();
}

void draw() 
{ 
  background(0);
 
  touchPoints.clear();
  for (int i=0; i< tiles.size(); i++)
  {
    Tile tile = (Tile) tiles.get(i);
    
    //  draw original tiles
    tile.draw();
    
    //  get & store their values in arraylists
    tiles_posX.set(i, tile.x);
    tiles_posY.set(i, tile.y);
    
    p1posX.set(i, tile.point1x + offset);
    p1posY.set(i, tile.point1y);
    p2posX.set(i, tile.point2x + offset);
    p2posY.set(i, tile.point2y);
    
    touchPoints.add(new TouchPoint(int(tile.point1x + offset), int(tile.point1y)));
    touchPoints.add(new TouchPoint(int(tile.point2x + offset), int(tile.point2y)));
  }
  
  
  //  track points
  tracker.detect(touchPoints);
  tracker.debugDraw();
  
  //  display info
  displayText();
}

boolean debounce = false;

void keyPressed()
{
  if (key == '1') addTile(1);
  if (key == '2') addTile(2);
  if (key == '3') addTile(3);
  if (key == '4') addTile(4);
  if (key == '5') addTile(5);
  if (key == '6') addTile(6);

  if ((key == 'd') && !debounce && !tiles.isEmpty())
  {
    debounce = true;
    
    tiles.remove(tiles.size()-1);
    tiles_posX.remove(tiles.size());
    tiles_posY.remove(tiles.size());
    p1posX.remove(tiles.size());
    p1posY.remove(tiles.size());
    p2posX.remove(tiles.size());
    p2posY.remove(tiles.size());
  }
}

void keyReleased()
{
  if (key == 'd')
    debounce = false;
}

void displayText()
{
  fill(255);
  textSize(12);
  text("PRESS '1-6' TO ADD SPECIFIC TILE / PRESS 'D' TO REMOVE LAST TILE", 20,height-40);
  
  fill(100);
  text("DRAG: LEFT MOUSE BUTTON, ROTATE: RIGHT MOUSE BUTTON", 20,height-20);
}

void addTile(int ID)
{
    tiles.add(new Tile(mouseX, mouseY, 100, 0, ID));
    tiles_posX.add(new Float(0.0));
    tiles_posY.add(new Float(0.0));
    p1posX.add(new Float(0.0));
    p1posY.add(new Float(0.0));
    p2posX.add(new Float(0.0));
    p2posY.add(new Float(0.0));
}

