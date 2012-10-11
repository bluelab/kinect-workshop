import SimpleOpenNI.*;
SimpleOpenNI kinect;

//create a PImage to store the depth image
PImage depthImage;

//set the range for the depth inspection 
int lowestValue=500;
int highestValue=850;

//this will be a running average and the current values
float closestX, lastX;
float closestY, lastY;

// create arrays to store recent
// closest x- and y-values for averaging
int averagingLenght=10;
int[] recentXValues = new int[averagingLenght];
int[] recentYValues = new int[averagingLenght];

// keep track of which is the current
// value in the array to be changed
int currentIndex = 0;

void setup() {  
  size(640, 480);  
  kinect = new SimpleOpenNI(this);  
  kinect.enableDepth();
  kinect.setMirror(true);
}

void draw() {  
  int  closestValue = 8000;  
  kinect.update();
  depthImage=kinect.depthImage();
  // get the depth array from the kinect
  int[] depthValues = kinect.depthMap();    
  // for each row in the depth image
  for (int y = 0; y < 480; y++) {   
    // look at each pixel in the row   
    for (int x = 0; x < 640; x++) {       
      // pull out the corresponding value from the depth array
      int i = x + y * 640;        
      int currentDepthValue = depthValues[i];
      // if that pixel is the closest one we've seen so far
      if (currentDepthValue > lowestValue && currentDepthValue < highestValue && currentDepthValue < closestValue) {          
        // save its value
        closestValue = currentDepthValue;  
        // and save its position          
        // into our recent values arrays        
        recentXValues[currentIndex] = x;
        recentYValues[currentIndex] = y;
      }
      if (currentDepthValue < lowestValue || currentDepthValue > highestValue ) {          
        depthImage.pixels[i] = 0;
      }
    }
  }
  // cycle current index through 0,1,2:  
  currentIndex++;  
  if (currentIndex >= averagingLenght) {    
    currentIndex = 0;
  }

  // closestX and closestY become  
  // a running average with currentX and currentY 
  closestX =0;
  closestY =0;
 for(int i=0 ; i< averagingLenght; i++){ 
  closestX =+ recentXValues[i]/3;
  closestY =+ recentYValues[i]/3;

  //draw the depth image
  //image(depthImage, 0, 0);

  // "linear interpolation", i.e.   
  // smooth transition between last point   
  // and new closest point   

  // set the line drawing color to blue  
  stroke(0, 0, 255);  
  //thicker line 
  strokeWeight(5);

  // draw a line from the previous point to the new closest one  
  line(lastX, lastY, closestX, closestY);  
  // save the closest point as the new previous one  
  lastX = closestX;  
  lastY = closestY;
}

void mousePressed() { 
  // save image to a file    
  // then clear it on the screen   
  //  save("~/Desktop/drawing.png");    
  background(0);
}

