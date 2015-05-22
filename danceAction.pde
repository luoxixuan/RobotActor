/* *
 * name:  the thread name;
 * t   :  wave or move times;
 * d   :  0->left, 1->right;
 * r   :  the robot we contolled;
 */
class danceAction extends Thread
{
  Robot robot;
  int times;
  int sleepTime;
  int danceSleepT;
  
  danceAction(String name, int s, int t, Robot r)
  {
    super(name);
    times       = t;
    robot       = r;
    sleepTime   = s;
    danceSleepT = r.getDanceSleepT();
  }
  
  void run()
  {
    dance();
  }
  
  //move to right
  void dance()
  {
    // left leg
    robot.moveL(times);
    print("dance\n");
    // Thread danceLThr = new MoveThread("danceMoveL", times, 0, danceSleepT, robot);
    // danceLThr.start();
    
    // sleep
    try 
      {
        Thread.sleep(sleepTime);
      } catch (InterruptedException e) 
      {
        e.printStackTrace();
      }
      
    // right leg
    robot.moveR(times);
    // Thread danceRThr = new MoveThread("danceMoveR", times, 1, danceSleepT, robot);
    // danceRThr.start();
    print("dance start");
  }
}
