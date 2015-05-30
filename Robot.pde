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
  float bodyHeight      = 70;
  
  // motorTorque
  float legMotorTorque  = 6000.0;
  float handMotorTorque = 5000.0;
  // speed
  float moveSpeed       = 3.0;
  float kickSpeed       = 100;
  float waveSpeed       = 2;
  
  // dance
  int   footIntervalT   = footIntervalTime;
  int   handIntervalT   = handIntervalTime;
  int   moveSleepT      = ninjaMoveSleepT;
  int   waveSleepT      = ninjaWaveSleepT;
  int   kickTimes       = ninjaKickTimes;
  int   waveTimes       = ninjaWaveTimes;
  
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
    // reset foot and hand to suitable status
    resetFoot();
    resetHand();
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
  
  // data reader
  int getMoveSleepT()
  {
    return moveSleepT;
  }
  int getWaveSleepT()
  {
    return waveSleepT;
  }
  int getDanceSleepT()
  {
    return footIntervalT;
  }
  
  // action
  // hand
  // set joint motor
  void waveLeftHand(float s)
  {
    handJointL.setMotorSpeed(s);
  }
  void waveRightHand(float s)
  {
    handJointR.setMotorSpeed(s);
  }
  // lift up and down hand
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
  // wave right hand action
  // wave once
  void singleWaveRightHand()
  {
    Thread singleWaveRThr = new WaveHandAction("singleWaveR", 1, 1, waveSleepT, this);
    singleWaveRThr.start();
  }
  // wave several times
  void waveRightHand(int waveTimes)
  {
    Thread waveThr = new WaveHandAction("wave", waveTimes, 1, waveSleepT, this);
    waveThr.start();
  }
  // Left
  // wave left hand action
  // wave once 
  void singleWaveLeftHand()
  {
    Thread singleWaveLThr = new WaveHandAction("singleWaveL", 1, 0, waveSleepT, this);
    singleWaveLThr.start();
  }
  // wave several times 
  void waveLeftHand(int waveTimes)
  {
    Thread waveLThr = new WaveHandAction("waveL", waveTimes, 0, waveSleepT, this);
    waveLThr.start();
  }
  
  // leg
  // lift up and down leg
  void liftLeftFoot(boolean motorOn)
  {
    legJointL.setMaxMotorTorque(legMotorTorque);
    if(motorOn)
    {
      if(legJointL.getMotorSpeed() < 0)
        legJointL.setMotorSpeed(moveSpeed);
      else
        legJointL.setMotorSpeed(-moveSpeed);
    }
    else
      legJointL.setMotorSpeed(0);
  }
  void liftRightFoot(boolean motorOn)
  {
    legJointR.setMaxMotorTorque(legMotorTorque);
    if(motorOn)
    {
      if(legJointR.getMotorSpeed() > 0)
        legJointR.setMotorSpeed(-moveSpeed);
      else
        legJointR.setMotorSpeed(moveSpeed);
    }
    else
      legJointR.setMotorSpeed(0);
  }
  // move action
  // left
  // single move
  void singleLiftL()
  {
    // liftLeftFoot(true);
    Thread singleMoveLThr = new LiftLegAction("singleLiftL", 1, 0, moveSleepT, this);
    singleMoveLThr.start();
  }
  // move serveral times
  void liftL(int step)
  {
    // liftLeftFoot(true);
    Thread liftLThr = new LiftLegAction("liftL", step, 0, moveSleepT, this);
    liftLThr.start();
  }
  // right
  // single move 
  void singleLiftR()
  {
    // liftLeftFoot(true);
    Thread singleLiftRThr = new LiftLegAction("singleLiftR", 1, 1, moveSleepT, this);
    singleLiftRThr.start();
  }
  // move several times
  void liftR(int step)
  {
    // liftRightFoot(true);
    Thread liftRThr = new LiftLegAction("liftR", step, 1, moveSleepT, this);
    liftRThr.start();
  }
  
  // dance action
  void dance()
  {
    // liftRightFoot(true);
    Thread danceThr = new DanceAction("dance", footIntervalT, handIntervalT, kickTimes, waveTimes, this);
    danceThr.start();
  }
  
  // kick
  void kickL()
  {
    //
  }
  
  void kickR()
  {
    //
  }
  
  // reset foot to suitable status
  void resetFoot()
  {
    liftLeftFoot(true);
    liftRightFoot(true);
    liftLeftFoot(true);
    liftRightFoot(true);
  }
  // reset foot to suitable status
  void resetHand()
  {
    waveLeftHand(true);
    waveRightHand(true);
  }
  
  // destroy
  void kill()
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
