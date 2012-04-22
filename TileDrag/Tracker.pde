class Tracker
{
  Tracker()
  {
    touchPoints = new ArrayList();
    
    print("distances ");
    for (int i = 0; i < distances.length; i++)
    {
      print(distances[i] + " ");
    }
    print("\n");
  }

  void detect(ArrayList pnts)
  {
    touchPoints = pnts;
  }

  void debugDraw()
  {
    // background
    fill(180);
    rectMode(CORNER);
    noStroke();
    rect(offset, 0, offset, height);

    for (int i = 0; i < touchPoints.size(); i++)
    {
      for (int j = i + 1; j < touchPoints.size(); j++) 
      {
        TouchPoint p0 = (TouchPoint)(touchPoints.get(i));
        TouchPoint p1 = (TouchPoint)(touchPoints.get(j));
        float d = sqrt(sq(p0.x - p1.x) + sq(p0.y - p1.y));

        int id = checkDistance(d);
        switch (id)
        {
          case 0:
            stroke(0, 255, 0);
            break;
            
          case 1:
            stroke(255, 0, 0);
            break;

          case 2:
            stroke(0, 0, 255);
            break;

          case 3:
            stroke(255, 0, 255);
            break;

          case 4:
            stroke(0, 255, 255);
            break;
            
          case 5:
            stroke(255, 255, 0);
            break;

          default:
            stroke(255, 255, 255);
            break;
        }

        line(p0.x, p0.y, p1.x, p1.y);
      }
    }
  }

  /* returns type id (0-5) from distance or -1 if the distance is unknown */
  int checkDistance(float d)
  {
    // allowed pixel deviation from distances
    float margin = 2;
    int found = -1;
    for (int i = 0; i < distances.length; i++)
    {
      if ((distances[i] - margin <= d) && (d < distances[i] + margin))
      {
        found = i;
        break;
      }
    }
    return found;
  }
  
  ArrayList touchPoints;

  /* calculates distance between points from tile size divisor in Tile class */
  float pdist(float m)
  {
    return d / m;
  }

  final int d = 100 * 2;
  final float[] distances =
  {
    pdist(2.58), 
    pdist(2.95), 
    pdist(3.26), 
    pdist(3.87), 
    pdist(4.76), 
    pdist(6.2)
  };
}

