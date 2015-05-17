enum displayMode{hand, leg, underpan, boxes}

class MyBox
{
  // We need to keep track of a Body and a width and height
  Body body;
  int type;
  float w;
  float h;
  float radius;

  // Constructor
  MyBox(float x, float y, float w_, float h_, float angle, int t) 
  {
    w = w_;
    h = h_;
    type = t;
     // Define the shape -- a  (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    sd.setAsBox(box2dW, box2dH);
    sd.m_radius = 0.1;
    
    // Define and create the body
    BodyDef bd = new BodyDef();
    bd.position.set(box2d.coordPixelsToWorld(new Vec2(x,y)));
    bd.type = BodyType.DYNAMIC;
    bd.angle = angle;
    //bd.fixedRotation = true;
    body = box2d.createBody(bd);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 3;
    fd.friction = 0.01;
    fd.restitution = 0.7;

    body.createFixture(fd);
  }

  // This function removes the particle from the box2d world
  void killBody() 
  {
    box2d.destroyBody(body);
  }
  
  Body getBody()
  {
    return body;
  }

  // Drawing the box
  void display() 
  {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    
    rectMode(PConstants.CENTER);
    pushMatrix();
      translate(pos.x,pos.y);
      rotate(-a);
      
      switch(type)
      {
        case 0://body
          image(ninjaBody, -ninjaBody.width/2.0, -ninjaBody.height/2.0);
          if(debug)
            rect(0, h/4, 6, h/2);
          break;
          
        case 1://Hand
          // fill(#F3C149);
          // noStroke();
          image(handImg, -handImg.width/2.0 - 12, -handImg.height/2.0);
          image(handImg,  handImg.width/2.0 - 12, -handImg.height/2.0);
          break;
          
        case 2://Leg
          image(legImg, -legImg.width/2.0, -legImg.height/2.0);
          break;
          
        case 3://underpan
          fill(#ede8d9);
          noStroke();
          if(debug)
            rect(0 ,0 ,w , h);
          image(legImg, legImg.width/2.0,       -8.0);
          image(legImg, legImg.width/2.0,       -8.0 + legImg.height);
          image(legImg, - 3 * legImg.width/2.0, -8.0);
          image(legImg, - 3 * legImg.width/2.0, -8.0 + legImg.height); //<>//
          break;
          
        case 4://else
          fill(#ede8d9);
          noStroke();
          rect(0 ,0 ,w , h);
          break;
      }
      // draw shape
      fill(#ede8d9);
      if(debug)
        rect(0.0, 0.0, w, h);
    popMatrix();
  }
}
