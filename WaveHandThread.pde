/* *
 * name:  the thread name;
 * t   :  wave or move times;
 * d   :  0->left, 1->right;
 * r   :  the robot we contolled;
 */
class WaveHandThread extends MyThread
{
  WaveHandThread(String name, int t, int d, Robot r)
  {
    super(name, t, d, r);
  }
  
  void run()
  {
    switch(dir)
    {
      case 0:
        waveLeftHand();
        break;
        
      case 1:
        waveRightHand();
        break;
    }
  }
  
  //move to right
  void waveRightHand()
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
      
      robot.waveRightHand(true);
      times --;
    }
  }
  
  void waveLeftHand()
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
      
      robot.waveLeftHand(true);
      times --;
    }
  }
}
