class Box
{
  // We need to keep track of a Body and a width and height
  Body body;
  int type;
  float w;
  float h;
  float radius;
  boolean isBody;

  // Constructor
  Box(float x, float y, float w_, float h_, float angle, boolean b) 
  {
    w = w_;
    h = h_;
    isBody = b;
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

    // Give it some initial random velocity
    //body.setLinearVelocity(new Vec2(random(-5,5),random(2,5)));
    //body.setAngularVelocity(random(-5,5));
  }

  // This function removes the particle from the box2d world
  void killBody() 
  {
    box2d.destroyBody(body);
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
      fill(#ede8d9);
      noStroke();
      // stroke(#ecdaa2);
      rect(0,0,w,h);
      if(isBody)
      {
        fill(255);
        noStroke();
        // stroke(#ecdaa2);
        rect(0, h/4, 6, h/2);
      }
    popMatrix();
  }
}
