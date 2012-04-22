class Tracker
{
  class PInfo
  {
    PInfo(int n)
    {
      distances = new float[n];
      distanceIds = new int[n];
      detected = false;
      pairIndex = -1;
      for (int i = 0; i < n; i++)
      {
        distances[i] = -1;
        distanceIds[i] = -1;
      }
      tileId = -1;
    }

    int checkDistances()
    {
      int r = UNKNOWN;
      int idx = 0;
      for (int i = 0; i < distances.length; i++)
      {
        if (distanceIds[i] != UNKNOWN)
        {
          if (r == UNKNOWN) // first known distance
          {
            r = distanceIds[i];
            idx = i;
          }
          else // second known distance, cannot deduct id
          {
            return UNKNOWN;
          }
        }
      }

      if (r == UNKNOWN) // all ids are unknown, reject point
      {
        tileId = REJECTED;
        return REJECTED;
      }

      // only one known distance
      detected = true;
      pairIndex = idx;
      tileId = r;
      return r;
    }

    static final int REJECTED = -2;
    static final int UNKNOWN = -1;

    float distances[]; // distances from other points
    int distanceIds[]; // id for distance or -1 if unknown
    boolean detected;  // set if its tile detected
    int pairIndex; // set to the index of its pair if tile is detected
    int tileId; // detected id or -1
  }

  class Tile
  {
    int p0;
    int p1;
    int id;
  }

  Tracker()
  {
    touchPoints = new ArrayList();

    print("distances ");
    for (int i = 0; i < idDistances.length; i++)
    {
      print(idDistances[i] + " ");
    }
    print("\n");
  }

  void detect(ArrayList pnts)
  {
    touchPoints = pnts;
    pinfos = new PInfo[touchPoints.size()];
    tiles = new ArrayList();

    for (int i = 0; i < touchPoints.size(); i++)
    {
      pinfos[i] = new PInfo(touchPoints.size());
    }

    // 1st pass - find points with only one known distance
    detectPass1();
    
    // TODO: extra passes
    for (int i = 0; i < 5; i++)
    {
      removeDetected();
      detectExtraPass(); // try extra pass again with remaining points
    }
  }

  // 1st pass - find points with only one known distance
  void detectPass1()
  {
    for (int i = 0; i < touchPoints.size(); i++)
    {
      for (int j = 0; j < touchPoints.size(); j++)
      {
        if (i == j)
          continue;

        TouchPoint p0 = (TouchPoint)(touchPoints.get(i));
        TouchPoint p1 = (TouchPoint)(touchPoints.get(j));
        float d = sqrt(sq(p0.x - p1.x) + sq(p0.y - p1.y));
        pinfos[i].distances[j] = d;
        pinfos[i].distanceIds[j] = checkDistance(d);
      }

      if (!pinfos[i].detected)
      {
        pinfos[i].checkDistances();

        // set pair and make tile
        if (pinfos[i].detected)
        {
          pinfos[ pinfos[i].pairIndex ].detected = true;
          pinfos[ pinfos[i].pairIndex ].pairIndex = i;
          pinfos[ pinfos[i].pairIndex ].tileId = pinfos[i].tileId;
          Tile t = new Tile();
          t.p0 = i;
          t.p1 = pinfos[i].pairIndex;
          t.id = pinfos[i].tileId;
          tiles.add(t);
        }
      }
    }
  }

 // extra pass - after removing known points
  void detectExtraPass()
  {
    for (int i = 0; i < touchPoints.size(); i++)
    {
      if (!pinfos[i].detected)
      {
        pinfos[i].checkDistances();

        // set pair and make tile
        if (pinfos[i].detected)
        {
          pinfos[ pinfos[i].pairIndex ].detected = true;
          pinfos[ pinfos[i].pairIndex ].pairIndex = i;
          pinfos[ pinfos[i].pairIndex ].tileId = pinfos[i].tileId;
          Tile t = new Tile();
          t.p0 = i;
          t.p1 = pinfos[i].pairIndex;
          t.id = pinfos[i].tileId;
          tiles.add(t);
        }
      }
    }
  }

  // remove possible point pairs that belong to other tiles
  void removeDetected()
  {
    for (int i = 0; i < pinfos.length; i++)
    {
      for (int j = 0; j < pinfos.length; j++)
      {
        if (!pinfos[i].detected && pinfos[j].detected)
        {
          pinfos[i].distanceIds[j] = -1;
        }
      }
    }
  }

  void debugDraw()
  {
    // background
    fill(180);
    rectMode(CORNER);
    noStroke();
    rect(offset, 0, offset, height);

    stroke(0);
    fill(0);
    textSize(14);
    for (int i = 0; i < tiles.size(); i++)
    {
      Tile t = (Tile)tiles.get(i);
      TouchPoint p0 = (TouchPoint)(touchPoints.get(t.p0));
      TouchPoint p1 = (TouchPoint)(touchPoints.get(t.p1));

      strokeFromId(t.id);

      line(p0.x, p0.y, p1.x, p1.y);

      stroke(0);
      ellipse(p0.x, p0.y, 5, 5);
      ellipse(p1.x, p1.y, 5, 5);

      text(t.id, (p0.x + p1.x) / 2., (p0.y + p1.y) / 2.);
    }

    // draw undetected point distances
    for (int i = 0; i < pinfos.length; i++)
    {
      TouchPoint p0 = (TouchPoint)(touchPoints.get(i));

      if (pinfos[i].detected)
        continue;

      for (int j = 0; j < pinfos.length; j++)
      {
        if (i == j)
          continue;

        TouchPoint p1 = (TouchPoint)(touchPoints.get(j));
        strokeFromId(pinfos[i].distanceIds[j]);  
        line(p0.x, p0.y, p1.x, p1.y);
      }
    }
  }

  // set stroke color from tile id
  void strokeFromId(int id)
  {
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
        stroke(255, 255, 255, 50);
        break;
    }
  }
  
  /* returns type id (0-5) from distance or -1 if the distance is unknown */
  int checkDistance(float d)
  {
    // allowed pixel deviation from distances
    float margin = 2;

    int found = -1;
    for (int i = 0; i < idDistances.length; i++)
    {
      if ((idDistances[i] - margin <= d) && (d < idDistances[i] + margin))
      {
        found = i;
        break;
      }
    }
    return found;
  }

  ArrayList touchPoints;
  PInfo pinfos[];
  ArrayList tiles;

  /* calculates distance between points from tile size divisor in Tile class */
  float pdist(float m)
  {
    return d / m;
  }

  // size of tile side
  final int d = 100 * 2;

  // known distance values for tile ids
  final float[] idDistances =
  {
    pdist(2.58), 
    pdist(2.95), 
    pdist(3.26), 
    pdist(3.87), 
    pdist(4.76), 
    pdist(6.2)
    };
  }

