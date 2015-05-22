/* *
 * name:  the thread name;
 * t   :  wave or move times;
 * d   :  0->left, 1->right;
 * r   :  the robot we contolled;
 */
class MyThread extends Thread
{
  int times;
  int sleepT;
  int dir;
  Robot robot;
  
  MyThread(String name, int t, int d, int s, Robot r)
  {
    super(name);
    times   = t * 2;
    dir     = d;
    sleepT  = s;
    robot   = r;
  }
}
