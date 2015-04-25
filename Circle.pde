class Circle
{
  // We need to keep track of a Body and a width and height
  Body body;
  float radius;
  boolean isWheel;

  // Constructor
  Circle(float x, float y, float r, boolean b) 
  {
    radius = r;
    isWheel = b;
    // Define the shape
    CircleShape circleShape = new CircleShape();
    circleShape.m_radius = radius/15;
    circleShape.m_p.set(0.0, 0.0);
   
    // Define and create the body
    BodyDef circleBodyDef = new BodyDef();
    circleBodyDef.position.set(box2d.coordPixelsToWorld(new Vec2(x,y)));
    circleBodyDef.type = BodyType.DYNAMIC;
    body = box2d.createBody(circleBodyDef);

    // Define a fixture
    FixtureDef circleFixDef = new FixtureDef();
    circleFixDef.shape = circleShape;
    // Parameters that affect physics
    circleFixDef.density = 1.0;
    circleFixDef.friction = 1.0;
    circleFixDef.restitution = 0.8;
    body.createFixture(circleFixDef);

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

    ellipseMode(PConstants.CENTER);
    pushMatrix();
      translate(pos.x,pos.y);
      rotate(-a);
      fill(#F3C149);
      noStroke();
      // stroke(#eac774);
      ellipse(0,0, radius, radius);
      if(isWheel)
      {
        noStroke();
        fill(0);
        rect(0.0, 0.0, radius/20, radius - 2);
      }
      else if(!isWheel)
      {
        noStroke();
        fill(#fff8b5);
        ellipse(   radius/6.0, 0.0, radius/15.0, radius/6.0);
        ellipse( - radius/6.0, 0.0, radius/15.0, radius/6.0);
      }
    popMatrix();
  }
}
