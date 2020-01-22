abstract class Interpolator
{
  Animation animation;
  
  // Where we at in the animation?
  float currentTime = 0;
  
  // To interpolate, or not to interpolate... that is the question
  boolean snapping = false;
  
  void SetAnimation(Animation anim)
  {
    animation = anim;
  }
  
  void SetFrameSnapping(boolean snap)
  {
    snapping = snap;
  }
  
   float getRatio(float current, float start, float end) {
    
    float range = end-start;
    
    float ratio = (current-start)/range; 
    
    if(ratio > 1) {
     return (current/end); 
    }
    else {
    return ratio;
    }
  }
  
  void UpdateTime(float time)
  {
    float dur = animation.GetDuration();
    if(time > 0) {
     if(currentTime > dur) {
     currentTime = currentTime%dur;
     }
     else {
     currentTime += time;   
     } 
    }
    else if (time < 0) {
      if(currentTime < 0 ) {
        currentTime = dur - (currentTime%dur);
      }
      else {
       currentTime += time;  
      }
    }
  }
  
  
  abstract void Update(float time);
}

class ShapeInterpolator extends Interpolator
{
  // The result of the data calculations - either snapping or interpolating
  PShape currentShape;
  
  // Changing mesh colors
  color fillColor;
  
  PShape GetShape()
  {
    return currentShape;
  }
  
  void Update(float time)
  {
    
    UpdateTime(time);
    KeyFrame[] reference =  animation.surroundingFrames(currentTime);
    KeyFrame before = reference[0];
    KeyFrame after = reference[1];
    float ratio = getRatio(currentTime, before.time, after.time);
    currentShape = createShape();
    //if snapping is true the animation will snap to the next keyframe of the animation.
    if(snapping) {
     currentShape.setStroke(false);
     currentShape.setFill(fillColor);
     currentShape.beginShape(TRIANGLES);
     for(int i = 0 ; i < after.points.size(); i++) {
       PVector vert = after.points.get(i);
       currentShape.vertex(vert.x, vert.y, vert.z);
     }
       currentShape.endShape();
    }
    //otherwise use the interpolation calculation to generate the frames between the keyframes 
   else {
     currentShape.setStroke(false);
     currentShape.setFill(fillColor);
     currentShape.beginShape(TRIANGLES);
     for(int i  = 0; i < after.points.size(); i++) {
      float deltaX = after.points.get(i).x - before.points.get(i).x;
      float deltaY = after.points.get(i).y - before.points.get(i).y;
      float deltaZ = after.points.get(i).z - before.points.get(i).z;
      PVector deltaP = new PVector(before.points.get(i).x+(deltaX*ratio), before.points.get(i).y+(deltaY*ratio), before.points.get(i).z+(deltaZ*ratio)); 
      currentShape.vertex(deltaP.x, deltaP.y, deltaP.z);
     }
     currentShape.endShape();
   }
    
  }
}

class PositionInterpolator extends Interpolator
{
  PVector currentPosition = new PVector(0,0,0);
  
  void Update(float time)
  {
    UpdateTime(time);
    KeyFrame[] reference = animation.surroundingFrames(currentTime);
    float ratio = getRatio(currentTime, reference[0].time, reference[1].time);
    
    if(snapping) {
     if(reference[1].time >= (currentTime+0.001)) {
       currentPosition = reference[1].points.get(0);
       return; 
     }
    }
    
    PVector before = reference[0].points.get(0);
    PVector after = reference[1].points.get(0);
    
    float deltaX, deltaY, deltaZ; 
    
    deltaX = after.x-before.x; 
    deltaY = after.y-before.y;
    deltaZ = after.z-before.z;
    
    currentPosition = new PVector(before.x+(ratio * deltaX), before.y+(ratio * deltaY), before.z+(ratio * deltaZ)); 
 
  }
}
