/* *
 * name:  the thread name;
 * t   :  wave or move times;
 * d   :  0->left, 1->right;
 * r   :  the robot we contolled;
 */
class DanceAction extends Thread
{
  Robot robot;
  int kickFootTimes;
  int waveHandTimes;
  int footIntervalT;
  int handIntervalT;
  
  DanceAction(String name, int ft, int ht, int kft, int wht, Robot r)
  {
    super(name);
    robot         = r;
    kickFootTimes = kft;
    waveHandTimes = wht;
    footIntervalT = ft;
    handIntervalT = ht;
  }
  
  void run()
  {
    footAction();
    handAction();
  }
  
  //move to right
  void footAction()
  {
    print("dance start\n");
    // left leg
    robot.moveL(kickFootTimes);
    
    // sleep
    try 
      {
        Thread.sleep(footIntervalT);
      } catch (InterruptedException e) 
      {
        e.printStackTrace();
      }
      
    // right leg
    robot.moveR(kickFootTimes);
  }
  
  void handAction()
  {
    // left hand
    robot.waveLeftHand(waveHandTimes);
    
    // sleep
    try 
      {
        Thread.sleep(handIntervalT);
      } catch (InterruptedException e) 
      {
        e.printStackTrace();
      }
      
    // right hand
    robot.waveRightHand(waveHandTimes);
  }
}
