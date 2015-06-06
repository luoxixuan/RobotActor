import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

import java.util.Date;
import java.text.SimpleDateFormat;
import java.lang.Thread;
import java.lang.Runnable;

import muthesius.net.*;
import org.webbitserver.*;

// debug
boolean debug = true;

// enum
enum MoveDir{left, right};

// websocket
WebSocketP5 socket;
String displayMsg;

// box2d
Box2DProcessing box2d;
float gra = -9.80;

// ninja robot
Robot ninja;
Robot ragdoll;
Robot ragdoll1;
// ninja data
int ninjaStepNum      = 10;
int ninjaWaveTimes    = 5;
int ninjaKickTimes   = 10;

int footIntervalTime  = 200; // ms
int handIntervalTime  = 2000; // ms
int ninjaWaveSleepT   = 2000;
int ninjaMoveSleepT   = 1000;

// lists we'll use to track fixed objects
ArrayList<Boundary> boundaries;
ArrayList<MyBox> boxes;
ArrayList<MyCircle> balls;

// image res
PImage ninjaImg;
PImage head,ninjaBody,handImg,rightHand,legImg,rightLeg;
void setup()
{
  size(1200, 700);
  smooth();
  background(255);
  
  // image resource
  // load image
  ninjaImg  = loadImage("res/ninja.png");
  head      = loadImage("res/ninjaHead.png");
  ninjaBody = loadImage("res/ninjaBody.png");
  handImg   = loadImage("res/ninjaHandS.png");
  legImg    = loadImage("res/ninjaLegS.png");
  // resize image
  head.resize((int)(head.width/3.2), (int)(head.height/3.2));
  legImg.resize((int)(legImg.width/3), (int)(legImg.height/4));
  handImg.resize((int)(handImg.width/2.5), (int)(handImg.height/2.6));
  ninjaBody.resize((int)(ninjaBody.width/3.4), (int)(ninjaBody.height/3));
  
  // socket init
  displayMsg = "";
  if(socket == null)
    socket = new WebSocketP5(this,8080);
  
  // box2d world init
  Vec2 gravity = new Vec2();
  gravity.set( 0, gra);
  box2d = new Box2DProcessing(this);
  box2d.createWorld(gravity);
  
  // boxes array init //<>//
  boxes = new ArrayList<MyBox>();
  balls = new ArrayList<MyCircle>();
  
  // Add some boundaries
  boundaries = new ArrayList<Boundary>();
  //Boundary(x,y,width,height)
  boundaries.add(new Boundary( width/2,  height - 4, width,      16));
  boundaries.add(new Boundary( width/2,           0, width,       0));
  boundaries.add(new Boundary(   width, height   /2,     0,  height));
  boundaries.add(new Boundary(       0, height   /2,     0,  height));
  
  //creat a robot
  ninja = new Robot(width/2, height - 100);
  ragdoll = new Robot(width/2 - 400, height - 100);
  ragdoll1 = new Robot(width/2 + 400, height - 100);
}

void draw()
{
  background(255);
  
  // box2d world update
  box2d.step();
  
  // text message 
  // guide info
  fill( 0, 200, 0);
  textSize(10);
  text("Press 'a' or 'd' 's' control the robot's motor", 20, 20);
  text("Or you can speak 'left' or 'right' and 'stop' to control the robot", 20, 40);
  // show command
  fill(0);
  textSize(20);
  text("Your Command:", 20, 70);
  textSize(20);
  text(displayMsg, 100, 90);
  
  // press the mouse button then add boxes
  if (mousePressed && (mouseButton == RIGHT)) 
  {
    MyBox p = new MyBox(mouseX,mouseY, random(20), random(20), random(PI), 4);
    boxes.add(p);
  }
  else if (mousePressed && (mouseButton == LEFT)) 
  {
    MyCircle p = new MyCircle(mouseX, mouseY, 10, 2);
    balls.add(p);
  }
  
  // show the ninja
  noStroke();
  if(debug)
    image( ninjaImg, 400, 180);
  if(ninja != null)
    ninja.display();// Show robotninja
  if(ragdoll != null)
    ragdoll.display();
  if(ragdoll1 != null)
    ragdoll1.display();
  // show the boundaries!
  for (Boundary wall: boundaries) 
  {
    wall.display();
  }
  // show boxes
  if(boxes.size() != 0)
  {
   for (MyBox box: boxes)
   {
     box.display();
   }
  }
  // show balls
  if(balls.size() != 0)
  {
    for (MyCircle ball: balls)
    {
      ball.display();
    }
  }
}

void stop()
{
  socket.stop();
  socket = null;
}

void mouseMoved()
{
  // drag ninja hand
}

void keyPressed()
{
  if(ninja != null)
  {
    // wave hand 
    // once
    if (keyCode == LEFT) 
    {
      ninja.waveLeftHand(true);
    }
    if (keyCode == RIGHT)
    {
      ninja.waveRightHand(true);
    }
    // several times
    if (keyCode == UP)
    {
      ninja.waveLeftHand(ninjaWaveTimes);
    }
    if (keyCode == DOWN)
    {
      ninja.waveRightHand(ninjaWaveTimes);
    }
    
    // move
    if (key == 'A' || key == 'a') 
    {
      ninja.singleLiftL();
    }
    if (key == 'D' || key == 'd') 
    {
      ninja.singleLiftR();
    }
    // single step move
    if (key == 'W' || key == 'w')
    {
      ninja.liftL(ninjaStepNum);
    ninja.waveLeftHand(true);
    }
    if (key == 'S' || key == 's')
    {
      ninja.liftR(ninjaStepNum);
    ninja.waveRightHand(true);
    }
    
    // dance 
    if (keyCode == 'X' || keyCode == 'x')
    {
      ninja.dance();
      if(ragdoll != null)
        ragdoll.dance();
      if(ragdoll1 != null)
        ragdoll1.dance();
    }
    
    // kick
    if (keyCode == 'J' || keyCode == 'j')
    {
      ninja.kickL();
    }
    if (keyCode == 'L' || keyCode == 'l')
    {
      ninja.kickR();
    }
  }
  
  if(ragdoll != null && ragdoll1 != null)
  {
    if(keyCode == 'K' || keyCode == 'k')
    {
      ragdoll.kill();
      ragdoll1.kill();
      
      ragdoll  = null;
      ragdoll1 = null;
    }
  }
    
  // reset all
  if (key == 'R' || key == 'r')
  {
    setup();
  }
}

// word controller
void wordCommand()
{
  if(displayMsg.indexOf("向左走")>=0 || displayMsg.indexOf("左")>=0)
  {
    displayMsg = "向左走";
    ninja.waveLeftHand(true);
    ninja.liftL(ninjaStepNum);
  }
  else if(displayMsg.indexOf("向右走")>=0 || displayMsg.indexOf("右")>=0)
  {
    displayMsg = "向右走";
    ninja.waveRightHand(true);
    ninja.liftR(ninjaStepNum);
  }
  else if(displayMsg.indexOf("手舞足蹈")>=0 || displayMsg.indexOf("舞")>=0 )
  {
    displayMsg = "手舞足蹈";
    ninja.dance();
    if(ragdoll != null)
      ragdoll.dance();
    if(ragdoll1 != null)
      ragdoll1.dance();
  }
  else if(displayMsg.indexOf("挥手告别")>=0)
  {
    displayMsg = "挥手告别";
  }
}
//websocket
void websocketOnMessage(WebSocketConnection con, String msg)
{
  println("msgget");
  println(msg);
  displayMsg = msg;
  
  //commander
  wordCommand();
}

void websocketOnOpen(WebSocketConnection con)
{
  println("A client joined");
}

void websocketOnClosed(WebSocketConnection con)
{
  println("A client left");
}
