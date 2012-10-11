/* --------------------------------------------------------------------------
 * SimpleOpenNI IR Test
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * Alex Barchiesi inspired by a prog of  Max Rheiner / 
 * ----------------------------------------------------------------------------
 */

import SimpleOpenNI.*;


SimpleOpenNI  kinect;

void setup()
{
  kinect = new SimpleOpenNI(this);

  // enable depthMap generation 
  if(kinect.enableDepth() == false)
  {
     println("Can't open the depthMap, maybe the camera is not connected!"); 
     exit();
     return;
  }
  
  // enable ir generation
  if(kinect.enableIR() == false)
  {
     println("Can't open the depthMap, maybe the camera is not connected!"); 
     exit();
     return;
  }
  
  background(0,0,0);
  size(kinect.depthWidth() + kinect.irWidth() + 10, kinect.depthHeight()); 
}

void draw()
{
  // update the cam
  kinect.update();
  
  // draw depthImageMap
  image(kinect.depthImage(),0,0);
  
  // draw irImageMap
  image(kinect.irImage(),kinect.depthWidth() + 10,0);
}
