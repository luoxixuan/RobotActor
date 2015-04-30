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
  float bodyHight = 100;
  float wheelRadius = 25;
  float speed = 5.0;
  
  MyBox underPan;
  MyBox robotBody;
  MyBox handR;
  MyBox handL;
  MyCircle robotHead;
  MyCircle wheelL;
  MyCircle wheelR;
  
  Robot(float x, float y) 
  {
    // Initialize body
    robotHead = new MyCircle(x, y - bodyHight - bodyHight/8.0 - 3, bodyHight/4.0, false);
    robotBody = new MyBox(x, y - bodyHight/2 - 3, bodyHight/2, bodyHight, 0, 0);
  
    handL = new MyBox(x - (bodyHight/4 + 16), y - bodyHight/2 - 10, bodyHight/2, 10, 0.0, 1);
    handR = new MyBox(x + (bodyHight/4 + 16), y - bodyHight/2 - 10, bodyHight/2, 10, 0.0, 2);
    
    underPan = new MyBox(x, y, panLen, 10.0, 0, 5);
    wheelR = new MyCircle(x + panLen/4, y + wheelRadius/2 + 10, wheelRadius, true);
    wheelL = new MyCircle(x - panLen/4, y + wheelRadius/2 + 10, wheelRadius, true);
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
    
    headJointDef.initialize(robotBody.getBody(), robotHead.getBody(), robotBody.getBody().getWorldCenter(), new Vec2(0.0, 1.0));
    
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
    MyJoint bodyJ = new MyJoint( 0, underPan.getBody(), robotBody.getBody(), new Vec2(0.0, 1.0));
    bodyJoint = (PrismaticJoint)bodyJ.getJoint();
    // Define joint as between two bodies
    // PrismaticJointDef bodyJointDef = new PrismaticJointDef();
    
    // bodyJointDef.initialize(underPan.body, robotBody.body, underPan.body.getWorldCenter(), new Vec2(0.0, 1.0));
    
    
    // // There are many other properties you can set for a Wheel joint
    // // For example, you can limit its angle between a minimum and a maximum
    // // See box2d manual for more
    // bodyJointDef.lowerTranslation = 0.0;
    // bodyJointDef.upperTranslation = 1.0;
    // bodyJointDef.enableLimit = true;
    // // Turning on a motor (optional)
    // bodyJointDef.motorSpeed = 0.0;;       // how fast?
    // bodyJointDef.maxMotorForce = 10.0; // how powerful?
    // bodyJointDef.enableMotor = true;      // is it on?
    
    // Create the joint
    // bodyJoint = (PrismaticJoint) box2d.world.createJoint(bodyJointDef);
  }
  
  void addHandJoint()
  {
    WeldJointDef handJointLDef = new WeldJointDef();
    WeldJointDef handJointRDef = new WeldJointDef();
    
    Vec2 handJointPos;
    handJointPos = robotBody.getBody().getWorldCenter();
    handJointLDef.initialize(robotBody.getBody(), handL.getBody(), handJointPos.add(new Vec2( bodyHight/4, -bodyHight/2)));
    handJointRDef.initialize(robotBody.getBody(), handR.getBody(), handJointPos.add(new Vec2(-bodyHight/4, -bodyHight/2)));
    
    handJointL = (WeldJoint) box2d.world.createJoint( handJointLDef);
    handJointR = (WeldJoint) box2d.world.createJoint( handJointRDef);
  }
  
  void addWheelJoint()
  {
    WheelJointDef wheelJLDef = new WheelJointDef();
    WheelJointDef wheelJRDef = new WheelJointDef();
    
    wheelJLDef.initialize(underPan.getBody(), wheelL.getBody(), wheelL.getBody().getWorldCenter(), new Vec2(0.0, 1.0));
    wheelJRDef.initialize(underPan.getBody(), wheelR.getBody(), wheelR.getBody().getWorldCenter(), new Vec2(0.0, 1.0));
    
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
    handL.display();
    handR.display();
    
    robotBody.display();
    
    underPan.display();
    wheelL.display();
    wheelR.display();
    robotHead.display();
  }
}
