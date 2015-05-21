/* *
 * name:  the thread name;
 * t   :  wave or move times;
 * d   :  0->left, 1->right;
 * r   :  the robot we contolled;
 */
class MyThread extends Thread
{
  int times;
  int dir;
  Robot robot;
  
  MyThread(String name, int s, int d, Robot r)
  {
    super(name);
    times   = s;
    dir     = d;
    robot   = r;
  }
}
