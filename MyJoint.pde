class MyJoint
{
  Joint j;
  
  MyJoint(int t,Body b1, Body b2, Vec2 v)
  {
    switch(t)
    {
    case 0:
      addPrimaticJoint(b1, b2, v);
      break;
    case 1:
      addWeldJoint(b1, b2, v);
      break;
    
    case 2:
      addWheelJoint(b1, b2, v);
      break;
    
    case 3:
      addHandL(b1, b2, v);
      break;
    
    case 4:
      addHandR(b1, b2, v);
      break;
    case 5:
      addLegR(b1, b2, v);
      break;
    case 6:
      addLegL(b1, b2, v);
      break;
    case 7:
      addFootR(b1, b2, v);
      break;
    case 8:
      addFootL(b1, b2, v);
      break;
    }   
  }
  
  void display()
  {
    
  }
  
  Joint getJoint()
  {
    return j;
  }
  // hand
  void addHandL(Body b1, Body b2, Vec2 v)
  {
    addRevoluteJoint(b1, b2, v, 0.22, -0.50);
  }
  void addHandR(Body b1, Body b2, Vec2 v)
  {
    addRevoluteJoint(b1, b2, v, 0.50, -0.22);
  }
  
  // leg
  void addLegL(Body b1, Body b2, Vec2 v)
  {
    addRevoluteJoint(b1, b2, v, 0.1, -0.0);
  }
  void addLegR(Body b1, Body b2, Vec2 v)
  {
    addRevoluteJoint(b1, b2, v, 0.0, -0.1);
  }
  // foot
  void addFootR(Body b1, Body b2, Vec2 v)
  {
    addRevoluteJoint(b1, b2, v, 0.30, -0.30);
  }
  void addFootL(Body b1, Body b2, Vec2 v)
  {
    addRevoluteJoint(b1, b2, v, 0.30, -0.30);
  }
  
  void addPrimaticJoint(Body b1, Body b2, Vec2 v)
  {
    // Define joint as between two bodies
    PrismaticJointDef bodyJointDef = new PrismaticJointDef();
    
    bodyJointDef.initialize(b1, b2, b1.getWorldCenter(), v);
    
    bodyJointDef.lowerTranslation  = 0.0;
    bodyJointDef.upperTranslation  = 1.0;
    bodyJointDef.enableLimit       = true;
    // Turning on a motor (optional)
    bodyJointDef.motorSpeed        = 0.0;       // how fast?
    bodyJointDef.maxMotorForce     = 10.0;    // how powerful?
    bodyJointDef.enableMotor       = true;      // is it on?
   
    // Create the joint
    j = box2d.world.createJoint(bodyJointDef);
  }
  
  void addWeldJoint(Body b1, Body b2, Vec2 v)
  {
    WeldJointDef handJDef = new WeldJointDef();
    
    Vec2 handJointPos;
    handJointPos = b2.getWorldCenter();
    handJDef.initialize(b2, b1, handJointPos.add(v));
  
    j = box2d.world.createJoint( handJDef);
  }
  
  void addWheelJoint(Body b1, Body b2, Vec2 v)
  {
    WheelJointDef WheelJoint    = new WheelJointDef();
    WheelJoint.initialize(b1, b2, b2.getWorldCenter(), new Vec2(0.0, 1.0));
    
    WheelJoint.motorSpeed       = 0;       // how fast?
    WheelJoint.maxMotorTorque   = 14000.0; // how powerful?
    WheelJoint.enableMotor      = true;      // is it on?
    WheelJoint.collideConnected = true;
    WheelJoint.frequencyHz      = 2.0f;
    WheelJoint.dampingRatio     = 0.1f;
    
    j = (WheelJoint) box2d.world.createJoint(WheelJoint);
  }
  
  void addRevoluteJoint(Body b1, Body b2, Vec2 v, float limitUp, float limitDown)
  {
    RevoluteJointDef RevoluteJoint     = new RevoluteJointDef();
    RevoluteJoint.initialize(b1, b2, v);
    RevoluteJoint.lowerAngle           = limitDown * PI; // -135 degrees
    RevoluteJoint.upperAngle           = limitUp * PI; // 45 degrees
    RevoluteJoint.enableLimit          = true;
    RevoluteJoint.maxMotorTorque       = 10000.0f;
    RevoluteJoint.motorSpeed           = 0.0f;
    RevoluteJoint.enableMotor          = true;
    j = (RevoluteJoint) box2d.world.createJoint(RevoluteJoint);
  }
}
