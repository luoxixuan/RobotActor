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

import muthesius.net.*;
import org.webbitserver.*;

// debug
boolean debug = false;

// websocket
WebSocketP5 socket;
String displayMsg;
// box2d
Box2DProcessing box2d;
float gra = -9.80;
// ninjarobot
Robot ninja;
// A list we'll use to track fixed objects
ArrayList<Boundary> boundaries;
ArrayList<MyBox> boxes;

PImage ninjaImg;
PImage head,ninjaBody,handImg,rightHand,legImg,rightLeg;
void setup()
{
  size(1200, 700);
  smooth();
  background(255);
  
  // image resource
  // load image
  ninjaImg     = loadImage("res/ninja.png");
  head      = loadImage("res/ninjaHead.png");
  ninjaBody = loadImage("res/ninjaBody.png");
  handImg  = loadImage("res/ninjaHandS.png");
  legImg   = loadImage("res/ninjaLegS.png");
  // resize image
  head.resize((int)(head.width/3.2), (int)(head.height/3.2));
  legImg.resize((int)(legImg.width/3), (int)(legImg.height/4));
  handImg.resize((int)(handImg.width/2.5), (int)(handImg.height/2.6));
  ninjaBody.resize((int)(ninjaBody.width/3.4), (int)(ninjaBody.height/3));
  
  // socket init
  displayMsg = "";
  socket = new WebSocketP5(this,8080);
  
  // box2d world init
  Vec2 gravity = new Vec2();
  gravity.set( 0, gra);
  box2d = new Box2DProcessing(this);
  box2d.createWorld(gravity);
  
  // boxes array init //<>//
  boxes = new ArrayList<MyBox>();
  
  // Add some boundaries
  boundaries = new ArrayList<Boundary>();
  //Boundary(x,y,width,height)
  boundaries.add(new Boundary( width/2,  height - 4, width,      16));
  boundaries.add(new Boundary( width/2,           0, width,       0));
  boundaries.add(new Boundary(   width, height   /2,     0,  height));
  boundaries.add(new Boundary(       0, height   /2,     0,  height));
  
  //creat a robot
  ninja = new Robot(width/2, height - 50);
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
  
  // show the ninja
  if(debug)
    image( ninjaImg, 400, 180);
  ninja.display();// Show robotninja
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
}

void stop()
{
  socket.stop();
}

void mouseMoved()
{
  // drag ninja hand
}

void keyPressed()
{
  if (keyCode == LEFT) 
  {
    ninja.waveLeftHand(true);
  }
  if (keyCode == RIGHT)
  {
    ninja.waveRightHand(true);
  }
  if (keyCode == DOWN)
  {
    ninja.waveRightHand(false);
    ninja.waveLeftHand(false);
  }
  if (key == 'A' || key == 'a') 
  {
    ninja.setMotor(-1.0);
  }
  if (key == 'D' || key == 'd') 
  {
    ninja.setMotor(1.0);
  }
  if (key == 'S' || key == 's')
  {
    ninja.setMotor(0.0);
  }
  if (key == 'R' || key == 'r')
  {
    setup();
  }
}

void wordCommand()
{
  if(displayMsg.indexOf("le")>=0 || displayMsg.indexOf("ft")>=0)
  {
    println("left");
    displayMsg = "left";
    if(!ninja.motorOn())
    {
      ninja.toggleMotor();
    }
    ninja.setMotor(-1.0);
  }
  else if(displayMsg.indexOf("gh")>=0 || displayMsg.indexOf("ri")>=0)
  {
    println("right");
    displayMsg = "right";
    if(!ninja.motorOn())
    {
      ninja.toggleMotor();
    }
    ninja.setMotor(1.0);
  }
  
 else if(displayMsg.indexOf("st")>=0)
 {
   println("stop");
   displayMsg = "stop";
   
   ninja.setMotor(0.0);
 }
}

//websocket
void websocketOnMessage(WebSocketConnection con, String msg)
{
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
