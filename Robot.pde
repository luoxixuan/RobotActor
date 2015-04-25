class Robot 
{
  // Our object is two boxes and one joint
  // Consider making the fixed box much smaller 
  //and not drawing it
  WheelJoint wheelJointL;
  WheelJoint wheelJointR;
  
  WeldJoint handJointR;
  WeldJoint handJointL;
  
  PrismaticJoint bodyJoint;
  PrismaticJoint headJoint; 
  
  float panLen = 145;
  float bodyHight = 120;
  float wheelRadius = 25;
  float speed = 5.0;
  
  Box underPan;
  Box robotBody;
  Box handR;
  Box handL;
  Circle robotHead;
  Circle wheelL;
  Circle wheelR;
  
  Robot(float x, float y) 
  {
    // Initialize body
    robotHead = new Circle(x, y - bodyHight - bodyHight/8.0 - 3, bodyHight/4.0, false);
    robotBody = new Box(x, y - bodyHight/2 - 3, bodyHight/2, bodyHight, 0, true);
   
    handL = new Box(x + (bodyHight/4 + 10), y - bodyHight * 3.0/4.0, bodyHight/2, 10, PI*5/9, false);
    handR = new Box(x - (bodyHight/4 + 10), y - bodyHight * 3.0/4.0, bodyHight/2, 10, PI*4/9, false);
    
    underPan = new Box(x, y, panLen, 10.0, 0, false);
    wheelR = new Circle(x + panLen/4, y + wheelRadius/2 + 10, wheelRadius, true);
    wheelL = new Circle(x - panLen/4, y + wheelRadius/2 + 10, wheelRadius, true);
    //add joint
    addBodyJoint();
    addHeadJoint();
    addHandJoint();
    addWheelJoint();
  }

  void addHeadJoint()
  {
    // Define joint as between two bodies
    PrismaticJointDef headJointDef = new PrismaticJointDef();
    
    headJointDef.initialize(robotBody.body, robotHead.body, robotBody.body.getWorldCenter(), new Vec2(0.0, 1.0));
    
    // There are many other properties you can set for a Wheel joint
    // For example, you can limit its angle between a minimum and a maximum
    // See box2d manual for more
    headJointDef.lowerTranslation = 0.0;
    headJointDef.upperTranslation = 1.0;
    headJointDef.enableLimit = true;
    // Turning on a motor (optional)
    headJointDef.motorSpeed = 0.0;;       // how fast?
    headJointDef.maxMotorForce = 10.0; // how powerful?
    headJointDef.enableMotor = true;      // is it on?
   
    // Create the joint
    headJoint = (PrismaticJoint) box2d.world.createJoint(headJointDef);
  }

  void addBodyJoint()
  {
    // Define joint as between two bodies
    PrismaticJointDef bodyJointDef = new PrismaticJointDef();
    
    bodyJointDef.initialize(underPan.body, robotBody.body, underPan.body.getWorldCenter(), new Vec2(0.0, 1.0));
    
    
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
    bodyJoint = (PrismaticJoint) box2d.world.createJoint(bodyJointDef);
  }
  
  void addHandJoint()
  {
    WeldJointDef handJointLDef = new WeldJointDef();
    WeldJointDef handJointRDef = new WeldJointDef();
    
    Vec2 handJointPos;
    handJointPos = robotBody.body.getWorldCenter();
    handJointLDef.initialize(robotBody.body, handL.body, handJointPos.add(new Vec2( bodyHight/4, -bodyHight/2)));
    handJointRDef.initialize(robotBody.body, handR.body, handJointPos.add(new Vec2(-bodyHight/4, -bodyHight/2)));
    
    handJointL = (WeldJoint) box2d.world.createJoint( handJointLDef);
    handJointR = (WeldJoint) box2d.world.createJoint( handJointRDef);
  }
  
  void addWheelJoint()
  {
    WheelJointDef wheelJLDef = new WheelJointDef();
    WheelJointDef wheelJRDef = new WheelJointDef();
    
    wheelJLDef.initialize(underPan.body, wheelL.body, wheelL.body.getWorldCenter(), new Vec2(0.0, 1.0));
    wheelJRDef.initialize(underPan.body, wheelR.body, wheelR.body.getWorldCenter(), new Vec2(0.0, 1.0));
    
    wheelJLDef.motorSpeed = PI * speed * 0;       // how fast?
    wheelJLDef.maxMotorTorque = 14000.0; // how powerful?
    wheelJLDef.enableMotor = true;      // is it on?
    wheelJLDef.collideConnected = true;
    wheelJLDef.frequencyHz = 2.0f;
    wheelJLDef.dampingRatio = 0.1f;
    
    wheelJRDef.motorSpeed = PI * speed * 0;
    wheelJRDef.maxMotorTorque = 14000.0;
    wheelJRDef.enableMotor = true;
    wheelJRDef.collideConnected = true;
    wheelJRDef.frequencyHz = 2.0f;
    wheelJRDef.dampingRatio = 0.1f;

    
    wheelJointL = (WheelJoint) box2d.world.createJoint(wheelJLDef);
    wheelJointR = (WheelJoint) box2d.world.createJoint(wheelJRDef);
  }

  // Turn the motor on or off
  void toggleMotor() 
  {
    wheelJointL.enableMotor(!wheelJointL.isMotorEnabled());
    wheelJointR.enableMotor(!wheelJointR.isMotorEnabled());
  }

  void setMotor(float d)
  {
    //turn left
    if(d < 0)
    {
      if(wheelJointL.isMotorEnabled() == false)
      {
        wheelJointL.enableMotor(true);
      }
      wheelJointL.setMotorSpeed( -d * PI * speed );
      wheelJointR.enableMotor(false);
      wheelJointR.setMotorSpeed(0);
    }
    //turn right
    else if(d > 0)
    {
      if(wheelJointR.isMotorEnabled() == false)
      {
        wheelJointR.enableMotor(true);
      }
      wheelJointR.setMotorSpeed( -d * PI * speed );
      wheelJointL.enableMotor(false);
      wheelJointL.setMotorSpeed(0);
    }
    //stop
    else if(d == 0.0)
    {
      
      if(wheelJointR.isMotorEnabled())
      {
        wheelJointR.enableMotor(false);
        wheelJointL.setMotorSpeed(0);
        wheelJointL.enableMotor(true);
      }
      else if(wheelJointL.isMotorEnabled())
      {
        wheelJointL.enableMotor(false);
        wheelJointR.setMotorSpeed(0);
        wheelJointR.enableMotor(true);
      }
    }
  }

  boolean motorOn() 
  {
    return wheelJointL.isMotorEnabled();
  }

void killBody()
{
  robotHead.killBody();
  robotBody.killBody();
  handL.killBody();
  handR.killBody();
  underPan.killBody();
  wheelL.killBody();
  wheelR.killBody();
}

  void display() 
  {
    // println(box2d.coordWorldToPixels(robotHead.body.getWorldCenter()));
    // println(box2d.coordWorldToPixels(robotBody.body.getWorldCenter()));
    robotHead.display();
    robotBody.display();
    
    handL.display();
    handR.display();
    
    underPan.display();
    wheelL.display();
    wheelR.display();
  }
}
