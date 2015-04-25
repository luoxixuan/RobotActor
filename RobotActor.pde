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

WebSocketP5 socket;
String displayMsg;

Box2DProcessing box2d;
float gra = -9.80;

Robot robotActor;
// A list we'll use to track fixed objects
ArrayList<Boundary> boundaries;
ArrayList<Box> boxes;

void setup()
{
  size(1200, 400);
  smooth();
  background(255);
  //socket init
  displayMsg = "";
  socket = new WebSocketP5(this,8080);
  
  Vec2 gravity = new Vec2();
  gravity.set( 0, gra);
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld(gravity);
  
  // init boxes
  boxes = new ArrayList<Box>();
  // Add some boundaries
  boundaries = new ArrayList<Boundary>();
  //Boundary(x,y,width,height)
  boundaries.add(new Boundary( width/2,  height - 4, width,      16));
  boundaries.add(new Boundary( width/2,           0, width,       0));
  boundaries.add(new Boundary(   width, height   /2,     0,  height));
  boundaries.add(new Boundary(       0, height   /2,     0,  height));
  //creat a robot
  robotActor = new Robot(width/2, height - 60);
}

void draw()
{
  background(255);
  
  box2d.step();
  //text message 
  fill( 0, 200, 0);
  textSize(10);
  text("Press 'a' or 'd' 's' control the robot's motor", 20, 20);
  text("Or you can speak 'left' or 'right' and 'stop' to control the robot", 20, 40);
  
  fill(0);
  textSize(20);
  text("Your Command:", 20, 70);
  textSize(20);
  text(displayMsg, 100, 90);
  
  if (mousePressed) {
    Box p = new Box(mouseX,mouseY, random(20), random(20), random(PI), false);
    boxes.add(p);
  }
  
  robotActor.display();
  // Show the boundaries!
  for (Boundary wall: boundaries) 
  {
    wall.display();
  }
  if(boxes.size() != 0)
  {
   for (Box box: boxes)
   {
     box.display();
   }
  }
  SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
  //println(df.format(new Date()));
}

void stop()
{
  socket.stop();
}

void mousePressed()
{
  
}

void keyPressed()
{
  if (key == 'A' || key == 'a') 
  {
    robotActor.setMotor(-1.0);
  }
  if (key == 'D' || key == 'd') 
  {
    robotActor.setMotor(1.0);
  }
  if (key == 'S' || key == 's')
  {
    robotActor.setMotor(0.0);
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
    if(!robotActor.motorOn())
    {
      robotActor.toggleMotor();
    }
    robotActor.setMotor(-1.0);
  }
  else if(displayMsg.indexOf("gh")>=0 || displayMsg.indexOf("ri")>=0)
  {
    println("right");
    displayMsg = "right";
    if(!robotActor.motorOn())
    {
      robotActor.toggleMotor();
    }
    robotActor.setMotor(1.0);
  }
  
 else if(displayMsg.indexOf("st")>=0)
 {
   println("stop");
   displayMsg = "stop";
   
   robotActor.setMotor(0.0);
 }
}

//websocket
void websocketOnMessage(WebSocketConnection con, String msg)
{
  println(msg);
  displayMsg = msg;
  
  //commander
  wordCommand();
  // println("1");
}

void websocketOnOpen(WebSocketConnection con)
{
  println("A client joined");
}

void websocketOnClosed(WebSocketConnection con)
{
  println("A client left");
}
