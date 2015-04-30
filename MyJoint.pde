class MyJoint
{
  // RevoluteJoint jointL;
  Joint j;
  // RevoluteJointDef wheelJLDef;
  
  MyJoint(int t,Body b1, Body b2, Vec2 v)
  {
    switch(t)
    {
    case 0:
      addPrimaticJoint(b1, b2, v);
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
  
  void addPrimaticJoint(Body b1, Body b2, Vec2 v)
  {
    // Define joint as between two bodies
    PrismaticJointDef bodyJointDef = new PrismaticJointDef();
    
    bodyJointDef.initialize(b1, b2, b1.getWorldCenter(), v);
    
    
    // There are many other properties you can set for a Wheel joint
    // For example, you can limit its angle between a minimum and a maximum
    // See box2d manual for more
    bodyJointDef.lowerTranslation = 0.0;
    bodyJointDef.upperTranslation = 1.0;
    bodyJointDef.enableLimit = true;
    // Turning on a motor (optional)
    bodyJointDef.motorSpeed = 0.0;;       // how fast?
    bodyJointDef.maxMotorForce = 10.0; // how powerful?
    bodyJointDef.enableMotor = true;      // is it on?
   
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
}
