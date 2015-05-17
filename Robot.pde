int primaticType = 0;
int WeldType     = 1;
int wheelType    = 2;
int handLType    = 3; 
int handRType    = 4; 

class Robot 
{
  // position
  float x;
  float y;
  // body size 
  float panLen = 145;
  float bodyHight = 70;
  float wheelRadius = 25;
  float speed = 5.0;
  
  // body
  MyBox underPan;
  MyBox robotBody;
  MyBox handR;
  MyBox handL;
  MyCircle robotHead;
  MyCircle wheelL;
  MyCircle wheelR;
  
  //joint
  WheelJoint wheelJointL;   // wheel and underpan
  WheelJoint wheelJointR;
  RevoluteJoint handJointR; // hand and body
  RevoluteJoint handJointL;
  PrismaticJoint bodyJoint; // body and underpan
  PrismaticJoint headJoint; // head and body
  
  Robot(float xt, float yt) 
  {
    // Initialize body
    x = xt;
    y = yt;
    // add body widget
    addBody();
    addHead();
    addHand();
    addWheel();
  }
  // add joint
  void addHead()
  {
    // create head
    robotHead = new MyCircle(x, y - bodyHight - bodyHight/3.0, 84, false);
    // Create the joint
    MyJoint j = new MyJoint(primaticType ,robotBody.getBody(), robotHead.getBody(), new Vec2(0.0, 1.0));
    headJoint = (PrismaticJoint) j.getJoint();
  }

  void addBody()
  {
    // create body&underpan
    robotBody = new MyBox(x, y - 30, 75, bodyHight, 0, 0);
    underPan = new MyBox(x, y, panLen, 10.0, 0, 3);
    // create joint between body&uderpan
    MyJoint j = new MyJoint( primaticType, underPan.getBody(), robotBody.getBody(), new Vec2(0.0, 1.0));
    bodyJoint = (PrismaticJoint)j.getJoint();
  }
  
  void addHand()
  {
    // create hand
    handL = new MyBox(x - 55, y - 30, bodyHight/2, 10, -40, 1);
    handR = new MyBox(x + 55, y - 30, bodyHight/2, 10,  40, 1);
    
    // create joint hand&body
    // left joint
    MyJoint j  = new MyJoint(handLType, robotBody.getBody(), handL.getBody(), handL.getBody().getWorldPoint(new Vec2(-2, 0)));
    handJointL = (RevoluteJoint) j.getJoint();
    // right joint
    j  = new MyJoint(handRType, robotBody.getBody(), handR.getBody(), handR.getBody().getWorldPoint(new Vec2(2, 0)));
    handJointR = (RevoluteJoint) j.getJoint(); //<>//
  }
  
  void addWheel()
  {
    // create wheel
    wheelR = new MyCircle(x + panLen/4, y + wheelRadius/2 + 10, wheelRadius, true);
    wheelL = new MyCircle(x - panLen/4, y + wheelRadius/2 + 10, wheelRadius, true);
    
    // left wheel joint
    MyJoint j = new MyJoint( wheelType, underPan.getBody(), wheelL.getBody(), new Vec2(0.0, 1.0));
    wheelJointL = (WheelJoint) j.getJoint();
    // right  wheel joint
    j = new MyJoint( wheelType, underPan.getBody(), wheelR.getBody(), new Vec2(0.0, 1.0));
    wheelJointR = (WheelJoint) j.getJoint();
  }
  // action
  void waveRightHand(boolean motorOn)
  {
    if(motorOn)
    {
      if(handJointR.getMotorSpeed() == 2)
        handJointR.setMotorSpeed(-2);
      else
        handJointR.setMotorSpeed(2);
    }
    else
      handJointR.setMotorSpeed(0);
  }
  void waveLeftHand(boolean motorOn)
  {
    if(motorOn)
    {
      if(handJointL.getMotorSpeed() == 2)
        handJointL.setMotorSpeed(-2);
      else
        handJointL.setMotorSpeed(2);
    }
    else
      handJointL.setMotorSpeed(0);
  }
  
  // foot
  // set move direction
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
    else
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
  // Turn the motor on or off
  void toggleMotor() 
  {
    wheelJointL.enableMotor(!wheelJointL.isMotorEnabled());
    wheelJointR.enableMotor(!wheelJointR.isMotorEnabled());
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
