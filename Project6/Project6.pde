// VertexAnimation Project - Student Version
import java.io.*;
import java.util.*;
import controlP5.*;
/*========== Monsters ==========*/
Animation monsterAnim;
ShapeInterpolator monsterForward = new ShapeInterpolator();
ShapeInterpolator monsterReverse = new ShapeInterpolator();
ShapeInterpolator monsterSnap = new ShapeInterpolator();

/*========== Sphere ==========*/
Animation sphereAnim; // Load from file
Animation spherePos; // Create manually
ShapeInterpolator sphereForward = new ShapeInterpolator();
PositionInterpolator spherePosition = new PositionInterpolator();

/*Cubes*/
Animation cubeAnimation;

// TODO: Create animations for interpolators
ArrayList<PositionInterpolator> cubes = new ArrayList<PositionInterpolator>();

//Camera
Camera look;
PShape cube; 
float zoom;
PVector place = new PVector(0,0,0);


void setup()
{
//  pixelDensity(2);
  size(800, 600, P3D);
  //perspective(-radians(50.0f), -width/(float)height, 0.1, 1000);
  /*====== Load Animations ======*/
  monsterAnim = ReadAnimationFromFile("monster.txt");
  sphereAnim = ReadAnimationFromFile("sphere.txt");

  monsterForward.SetAnimation(monsterAnim);
  monsterReverse.SetAnimation(monsterAnim);
  monsterSnap.SetAnimation(monsterAnim);  
  monsterSnap.SetFrameSnapping(true);

  sphereForward.SetAnimation(sphereAnim);

  /*====== Create Animations For Cubes ======*/
  // When initializing animations, to offset them
  // you can "initialize" them by calling Update()
  // with a time value update. Each is 0.1 seconds
  // ahead of the previous one
  
  KeyFrame one = new KeyFrame(0.5f, new PVector(0,0,0));
  KeyFrame two = new KeyFrame(1.0f, new PVector(0,0,100));
  KeyFrame three = new KeyFrame(1.5f, new PVector(0,0));
  KeyFrame four = new KeyFrame(2.0f, new PVector(0,0,-100));
  
  ArrayList<KeyFrame> cubesFrames = new ArrayList<KeyFrame>();
  cubesFrames.add(one);
  cubesFrames.add(two);
  cubesFrames.add(three);
  cubesFrames.add(four);
  
  cubeAnimation = new Animation(cubesFrames);
  
  for(int i = 0; i < 11; i++) {
   PositionInterpolator inter = new PositionInterpolator();
   inter.SetAnimation(cubeAnimation);
   
   if(i % 2 != 0) 
   inter.SetFrameSnapping(true);
   
   inter.Update(.1f*i);
   cubes.add(inter);
   
  }
  /*====== Create Animations For Spheroid ======*/
  ArrayList <KeyFrame> keys = new ArrayList<KeyFrame>();
  one = new KeyFrame(1.0f, new PVector(-100,0,100));
  two = new KeyFrame(2.0f, new PVector(-100,0,-100));
  three = new KeyFrame(3.0f, new PVector(100,0,-100));
  four = new KeyFrame(4.0f, new PVector(100,0,100));
  keys.add(one);
  keys.add(two);
  keys.add(three);
  keys.add(four);
  Animation spherePos = new Animation(keys);
  spherePosition.SetAnimation(spherePos);
  
  
  look = new Camera();

}

void draw()
{
  lights();
  look.Update();
  look.Zoom(zoom);
  background(0);
  DrawGrid();
  
  float playbackSpeed = 0.005f;

  // TODO: Implement your own camera

  /*====== Draw Forward Monster ======*/
  //IMPORTANT !!!!!!
  
  pushMatrix();
  translate(-40, 0, 0);
  monsterForward.fillColor = color(128, 200, 54);
  monsterForward.Update(playbackSpeed);
  shape(monsterForward.currentShape);
  popMatrix();
  
  /*====== Draw Reverse Monster ======*/
  //IMPORTANT !!!!!!
  
  pushMatrix();
  translate(40, 0, 0);
  monsterReverse.fillColor = color(220, 80, 45);
  monsterReverse.Update(-playbackSpeed);
  shape(monsterReverse.currentShape);
  popMatrix();
  
  /*====== Draw Snapped Monster ======*/
    //IMPORTANT !!!!!!
  
  pushMatrix();
  translate(0, 0, -60);
  monsterSnap.fillColor = color(160, 120, 85);
  monsterSnap.Update(playbackSpeed);
  shape(monsterSnap.currentShape);
  popMatrix();
  
  /*====== Draw Spheroid ======*/
    //IMPORTANT !!!!!!
  
  spherePosition.Update(playbackSpeed);
  sphereForward.fillColor = color(39, 110, 190);
  sphereForward.Update(playbackSpeed);
  PVector pos = spherePosition.currentPosition;
  pushMatrix();
  translate(pos.x, pos.y, pos.z);
  shape(sphereForward.currentShape);
  popMatrix();
  
  /*====== TODO: Update and draw cubes ======*/
  // For each interpolator, update/draw
  
 
  float increments = 100; 
  cube = createShape(BOX, 10);
  for(int i = 0; i < 11; i++) {
  cubes.get(i).Update(playbackSpeed);
  pushMatrix();
  cube.setStroke(false);
  if(i % 2 != 0)
  cube.setFill(color(255,255,0));
  else
  cube.setFill(color(255,0,0));
  PVector position = cubes.get(i).currentPosition;
  translate(position.x+increments, position.y, position.z);
  shape(cube);
  popMatrix();
  increments -= 20; 
  }
}


// Create and return an animation object
Animation ReadAnimationFromFile(String fileName)
{
  
  Animation animation;
  ArrayList<KeyFrame> keys = new ArrayList<KeyFrame>();
  // The BufferedReader class will let you read in the file data
  try
  {
    BufferedReader reader = createReader(fileName);
    String line = reader.readLine();
    String buffer[];
    int keyframeInterations = Integer.parseInt(line);
    line = reader.readLine();
    int shapeInterations = Integer.parseInt(line);
    line = reader.readLine();
    float time = Float.parseFloat(line);
    for(int i = 0; i < keyframeInterations; i++) {
      ArrayList<PVector> frame = new ArrayList<PVector>();
      for(int j = 0; j < shapeInterations; j++) {
      line = reader.readLine();
      buffer = line.split(" ");
      PVector p = new PVector(Float.parseFloat(buffer[0]), Float.parseFloat(buffer[1]), Float.parseFloat(buffer[2]));
      frame.add(p);
      }
      keys.add(new KeyFrame(time,frame));
      if(i != keyframeInterations-1) {
      line = reader.readLine();
      time = Float.parseFloat(line);
      }
    }
  }
  catch (FileNotFoundException ex)
  {
    println("File not found: " + fileName);
  }
  catch (IOException ex)
  {
    ex.printStackTrace();
  }
  animation = new Animation(keys); 
  return animation;
}

void DrawGrid()
{
  gridGenerator();
  // TODO: Draw the grid
  // Dimensions: 200x200 (-100 to +100 on X and Z)
}

public class Camera {
      private float r; 
      private float phi;
      private float theta;
 //Camera constructor      
 Camera() {
 //Establish the base radius 
 r = 200;
 //Initialize the default camera 
 camera(150,150,150,
 width/2,height/2,0,
 0,1,0
 );
  }
  
 void Update() {
   //define the phi and theta angles 
   phi = radians(map(mouseX, 0, width-1, 0, 360));
   theta = radians(map(mouseY, 0, height-1, 1, 179));
   //Update the camera locations using spherical coordinates 
   float x= r*cos(phi)*sin(theta);
   float y = r*cos(theta);
   float z = r*sin(phi)*sin(theta);
   //Update the camera position
   camera(x+place.x,y+height/2,z+place.z,
   place.x, place.y,place.z,
   0,1,0);
  }


  //Applies the zoom if any to the camera 
  void Zoom(float position) {
   //Scales the zoom to 10 pixels per wheel scroll 
   float scale = zoom*10;
   float x= (r+scale)*cos(phi)*sin(theta);
   float y = (r+scale)*cos(theta);
   float z = (r+scale)*sin(phi)*sin(theta);
   camera(x+place.x, y+place.y, z,
   place.x, place.y, 0,
   0,1,0);
  }
  
}

//Generates the grid and sets the x-axis to red and z-axis to blue 
void gridGenerator() {
  pushMatrix();
    for(int j = -100; j <= 100; j += 10) {
    stroke(255);
    line(j, 0, -100, j, 0, 100);
    line(-100, 0, j, 100, 0, j);
    }

  stroke(0,0,255);
  line(0, 0, -100, 0, 0, 100);
  stroke(255,0,0);
  line(-100, 0, 0, 100, 0, 0);
 popMatrix();
}

//Updates the zoom counter when the mouse wheel is scrolled 
void mouseWheel(MouseEvent event) {
  zoom += event.getCount(); 
}
