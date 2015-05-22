/* *
 * name:  the thread name;
 * t   :  wave or move times;
 * d   :  0->left, 1->right;
 * r   :  the robot we contolled;
 */
class MoveThread extends MyThread
{
  MoveThread(String name, int t, int d, Robot r)
  {
    super(name, t, d, r);
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
        Thread.sleep(1000);
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
        Thread.sleep(1000);
      } catch (InterruptedException e) 
      {
        e.printStackTrace();
      }
      
      robot.liftLeftFoot(true);
      times --;
    }
  }
}
