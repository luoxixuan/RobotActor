class MyCircle
{
  // We need to keep track of a Body and a width and height
  Body body;
  float radius;
  int type;

  // Constructor
  MyCircle(float x, float y, float r, int t) 
  {
    radius = r;
    type = t;
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

    ellipseMode(PConstants.CENTER);
    pushMatrix();
      translate(pos.x,pos.y);
      rotate(-a);
      
      switch(type)
      {
      case 0:
        // draw wheel
        fill(#F3C149);
        noStroke();
        // stroke(#eac774);
        if(debug)
          ellipse(0,0, radius, radius);//draw circle
        // draw wheel shaft
        noStroke();
        fill(0);
        if(debug)
          rect(0.0, 0.0, radius/20, radius - 2);
        break;
        
      case 1:
        noStroke();
        fill(#fff8b5);
        if(debug)
        {
          ellipse(   radius/6.0, 0.0, radius/15.0, radius/6.0);
          ellipse( - radius/6.0, 0.0, radius/15.0, radius/6.0);
        }
        image( head, -head.width/2.0, -head.height/2.0);
        break;
        
      case 2:
        fill(#F3C149);
        noStroke();
        ellipse(0,0, radius, radius);//draw circle
        break;
      }
    popMatrix();
  }
}
