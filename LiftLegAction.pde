/* *
 * name:  the thread name;
 * t   :  wave or lift times;
 * d   :  0->left, 1->right;
 * r   :  the robot we contolled;
 */
class LiftLegAction extends MyThread
{
  LiftLegAction(String name, int t, int d, int s, Robot r)
  {
    super(name, t, d, s, r);
  }
  
  void run()
  {
    switch(dir)
    {
      case 0:
        liftLeftLeg();
        break;
        
      case 1:
        liftRightLeg();
        break;
    }
  }
  
  //move to right
  void liftRightLeg()
  {
    // sleep 1s
    while(times > 0)
    {
      try 
      {
        Thread.sleep(sleepT);
      } catch (InterruptedException e) 
      {
        e.printStackTrace();
      }
      
      robot.liftRightFoot(true);
      times --;
    }
  }
  
  void liftLeftLeg()
  {
    // sleep 1s
    while(times > 0)
    {
      try 
      {
        Thread.sleep(sleepT);
      } catch (InterruptedException e) 
      {
        e.printStackTrace();
      }
      
      robot.liftLeftFoot(true);
      times --;
    }
  }
}
