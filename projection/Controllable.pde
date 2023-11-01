public void MIDIUpdateControllable(int number, float value)
{
  if(controllables==null) initControllables();
  else {
    // update controllables
    for (Controllable controllable : controllables) {
      if(controllable.MIDINumber == number) {
        controllable.norm(value);
        controllable.disableAutomation();
      }
    }
  }
}

public void initControllables()
{
  controllables = new ArrayList<Controllable>();
}

public class Controllable 
{
  public String name = "";
  public int MIDINumber =  -1;
  public float minVal;
  public float maxVal;
  public float autoMinVal;
  public float autoMaxVal;
  public float value;
  public boolean isRoaming = false;
  public float roamingPhase = 0;
  public Toggle lowToggle = null;
  public Toggle highToggle = null;
  public Toggle roamingToggle = null;
  public Slider slider = null;
  
  public Controllable(String name, float value, float minVal, float maxVal)
  {
    this.name = name;
    this.value = value;
    this.autoMinVal = this.minVal = minVal;
    this.autoMaxVal = this.maxVal = maxVal;
    this.roamingPhase = random(10);

    if(controllables==null) initControllables();
    
    controllables.add(this);
  }
  
  public Controllable(String name, float value, float minVal, float maxVal, int MIDINumber)
  {
    this(name, value, minVal, maxVal);
    this.MIDINumber = MIDINumber;
  }
  
  public float val()
  {
    return value;
  }
  
  public void val(float value)
  {
    this.value = value;
    if (slider != null) slider.setValue(value);
  }
  
  public float norm()
  {
    return (value - minVal) / (maxVal-minVal);
  }
  
  public void norm(float value)
  {
    this.val(minVal + ( value * (maxVal - minVal) ));
  }
  
  public void disableAutomation() {
    this.isRoaming = false;
    if(lowToggle != null) lowToggle.setState(false);
    if(highToggle != null) highToggle.setState(false);
    if(roamingToggle != null) roamingToggle.setState(false);
  }
}
