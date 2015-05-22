int primaticType = 0;
int WeldType     = 1;
int wheelType    = 2;
int handLType    = 3;
int handRType    = 4;
int legLType     = 5;
int legRType     = 6;
int footLType    = 7;
int footRType    = 8;

class Robot 
{
  // position
  float x;
  float y;
  // body size 
  float bodyHeight  = 70;
  float speed       = 2.0;
  float kickSpeed   = 50;
  float waveSpeed   = 2;
  float stepT       = 2;
  
  // body
  MyBox robotBody;
  MyBox handR;
  MyBox handL;
  MyBox legL;
  MyBox legR;
  MyBox footL;
  MyBox footR;
  MyCircle robotHead;
  
  //joint
  // WheelJoint wheelJointL;   // wheel and underpan
  // WheelJoint wheelJointR;
  RevoluteJoint legJointR;  // leg and body
  RevoluteJoint legJointL;
  RevoluteJoint footJointR;  // foot and leg
  RevoluteJoint footJointL;
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
    addLeg();
    // reset foot to suitable status
    resetFoot();
    // addFoot();
    // addWheel();
  }
  // add joint
  void addHead()
  {
    // create head
    robotHead = new MyCircle(x, y - bodyHeight - bodyHeight/3.0, 84, 1);
    // Create the joint
    MyJoint j = new MyJoint(primaticType ,robotBody.getBody(), robotHead.getBody(), new Vec2(0.0, 1.0));
    headJoint = (PrismaticJoint) j.getJoint();
  }

  void addBody()
  {
    // create body&underpan
    robotBody = new MyBox(x, y - 30, 75, bodyHeight, 0, 0);
    // underPan = new MyBox(x, y, panLen, 10.0, 0, 3);
    // create joint between body&uderpan
    // MyJoint j = new MyJoint( primaticType, underPan.getBody(), robotBody.getBody(), new Vec2(0.0, 1.0));
    // bodyJoint = (PrismaticJoint)j.getJoint();
  }
  // add hand
  void addHand()
  {
    // create hand
    handL = new MyBox(x - 55, y - 30, bodyHeight/2, 10, -40, 1);
    handR = new MyBox(x + 55, y - 30, bodyHeight/2, 10,  40, 1);
    
    // create joint hand&body
    // left joint
    MyJoint j  = new MyJoint(handLType, robotBody.getBody(), handL.getBody(), handL.getBody().getWorldPoint(new Vec2(-2, 0)));
    handJointL = (RevoluteJoint) j.getJoint();
    // right joint
    j  = new MyJoint(handRType, robotBody.getBody(), handR.getBody(), handR.getBody().getWorldPoint(new Vec2(2, 0)));
    handJointR = (RevoluteJoint) j.getJoint(); //<>//
  }
  // add leg
  void addLeg()
  {
    // create Leg
    legL = new MyBox(x - legImg.width, y - 25 + bodyHeight, legImg.width, legImg.height, 0, 2);
    legR = new MyBox(x + legImg.width, y - 25 + bodyHeight, legImg.width, legImg.height, 0, 2);
    
    // create joint leg&body
    // left joint
    MyJoint j  = new MyJoint(legLType, robotBody.getBody(), legL.getBody(), robotBody.getBody().getWorldPoint(new Vec2(-0.5, 0.5)));
    legJointL = (RevoluteJoint) j.getJoint();
    // right joint
    j  = new MyJoint(legRType, robotBody.getBody(), legR.getBody(), robotBody.getBody().getWorldPoint(new Vec2(0.5, 0.5)));
    legJointR = (RevoluteJoint) j.getJoint();
  }
  
  void addFoot()
  {
    // create Leg
    footL = new MyBox(x - legImg.width, y - 20 + bodyHeight, bodyHeight/2, 10, 0, 2);
    footR = new MyBox(x + legImg.width, y - 20 + bodyHeight, bodyHeight/2, 10, 0, 2);
    
    // create joint foot&body
    // left joint
    MyJoint j  = new MyJoint(footLType, legL.getBody(), footL.getBody(), footL.getBody().getWorldPoint(new Vec2(-2, 0)));
    footJointL = (RevoluteJoint) j.getJoint();
    // right joint
    j  = new MyJoint(footRType, legR.getBody(), footR.getBody(), footR.getBody().getWorldPoint(new Vec2(-2, 0)));
    footJointR = (RevoluteJoint) j.getJoint();
  }
  
  // action
  // hand
  // wave hand
  // Right
  void waveRightHand(float s)
  {
    handJointR.setMotorSpeed(s);
  }
  void waveRightHand(boolean motorOn)
  {
    if(motorOn)
    {
      if(handJointR.getMotorSpeed() < 0)
        waveRightHand(waveSpeed);
      else
        waveRightHand(-waveSpeed);
    }
    else
      handJointR.setMotorSpeed(waveSpeed);
  }
  
  void waveRightHand(int waveTimes)
  {
    Thread waveThr = new WaveHandThread("wave", waveTimes, 1, this);
    waveThr.start();
  }
  // Left
  void waveLeftHand(float s)
  {
    handJointL.setMotorSpeed(s);
  }
  void waveLeftHand(boolean motorOn)
  {
    if(motorOn)
    {
      if(handJointL.getMotorSpeed() > 0)
        waveLeftHand(-waveSpeed);
      else
        waveLeftHand(waveSpeed);
    }
    else
      handJointL.setMotorSpeed(0);
  }
  void waveLeftHand(int waveTimes)
  {
    Thread waveThr = new WaveHandThread("wave", waveTimes, 0, this);
    waveThr.start();
  }
  
  // foot
  // move step by step
  void liftLeftFoot(boolean motorOn)
  {
    legJointL.setMaxMotorTorque(5000.0);
    if(motorOn)
    {
      if(legJointL.getMotorSpeed() < 0)
        legJointL.setMotorSpeed(speed);
      else
        legJointL.setMotorSpeed(-speed);
    }
    else
      legJointL.setMotorSpeed(0);
  }
  void liftRightFoot(boolean motorOn)
  {
    legJointR.setMaxMotorTorque(5000.0);
    if(motorOn)
    {
      if(legJointR.getMotorSpeed() > 0)
        legJointR.setMotorSpeed(-speed);
      else
        legJointR.setMotorSpeed(speed);
    }
    else
      legJointR.setMotorSpeed(0);
  }
  // move step by step
  // left
  void moveL(int step)
  {
    // liftLeftFoot(true);
    Thread moveThr = new MoveThread("move", step, 0, this);
    moveThr.start();
  }
  // right
  void moveR(int step)
  {
    // liftRightFoot(true);
    Thread moveThr = new MoveThread("move", step, 1, this);
    moveThr.start();
  }
  
  // kick
  void kickL()
  {
    legJointL.setMaxMotorTorque(50000.0);
    if(legJointL.getMotorSpeed() > 0)
      legJointL.setMotorSpeed(-kickSpeed);
    else
    {
      legJointL.setMaxMotorTorque(5000.0);
      legJointL.setMotorSpeed(kickSpeed);
    }
  }
  void kickR()
  {
    legJointR.setMaxMotorTorque(50000.0);
    if(legJointR.getMotorSpeed() < 0)
      legJointR.setMotorSpeed(kickSpeed);
    else
    {
      legJointR.setMaxMotorTorque(5000.0);
      legJointR.setMotorSpeed(-kickSpeed);
    }
  }
  
  // reset foot to suitable status
  void resetFoot()
  {
    liftLeftFoot(true);
    liftRightFoot(true);
    liftLeftFoot(true);
    liftRightFoot(true);
  }
  
  // destroy
  void killBody()
  {
    robotHead.killBody();
    robotBody.killBody();
    handL.killBody();
    handR.killBody();
    legL.killBody();
    legR.killBody();
    // footL.killBody();
    // footR.killBody();
  }

  void display() 
  {
    handL.display();
    handR.display();
    
    legL.display();
    legR.display();
    // footL.display();
    // footR.display();
    robotBody.display();
    robotHead.display();
  }
}
