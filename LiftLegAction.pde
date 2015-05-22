/* *
 * name:  the thread name;
 * t   :  wave or move times;
 * d   :  0->left, 1->right;
 * r   :  the robot we contolled;
 */
class MoveThread extends MyThread
{
  MoveThread(String name, int t, int d, int s, Robot r)
  {
    super(name, t, d, s, r);
  }
  
  void run()
  {
    switch(dir)
    {
      case 0:
        moveToLeft();
        break;
        
      case 1:
        moveToRight();
        break;
    }
  }
  
  //move to right
  void moveToRight()
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
  
  void moveToLeft()
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
