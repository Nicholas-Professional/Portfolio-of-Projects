// Snapshot in time of some amount of data
class KeyFrame
{
  // Where does this thing occur in the animation?
  public float time;
  
  // Because translation and vertex positions are the same thing, this can
  // be reused for either. An array of one is perfectly viable.
  public ArrayList<PVector> points = new ArrayList<PVector>(); 
  
  KeyFrame(float time, ArrayList<PVector> points) {
    this.time = time; 
    this.points = points; 
  }
  
  KeyFrame(float time, PVector position) {
    this.time = time; 
     points.add(position); 
  }
}

class Animation
{
  // Animations start at zero, and end... here
  float GetDuration()
  {
    return keyFrames.get(keyFrames.size()-1).time;
  }
  
  KeyFrame[] surroundingFrames(float current) {
    KeyFrame[] paired = new KeyFrame[2];
    KeyFrame before = keyFrames.get(keyFrames.size()-1);
    KeyFrame after = keyFrames.get(0);
    
    if(after.time < current) {
      for(KeyFrame i : keyFrames) {
        after = i; 
        if(after.time > current &&  current > before.time) 
        break;
        else {
        before = i;   
        }
      }
    }
      paired[0] = before;
      paired[1] = after;
      return paired; 
    }
  
 
  
  ArrayList<KeyFrame> keyFrames = new ArrayList<KeyFrame>();
  
  Animation(ArrayList<KeyFrame> keyFrames) {
    this.keyFrames = keyFrames; 
  }
  
}
