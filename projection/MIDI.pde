import themidibus.*;

MidiBus midiController = null;
boolean outputMIDI = true;

void initMIDI()
{
  // list all midi devices
  MidiBus.list();
  try{ midiController = new MidiBus(this, "SLIDER/KNOB", -1); } catch (Exception e) { println("DJ2Go not connected"); };
}

void noteOn(int channel, int pitch, int velocity) {
  if(outputMIDI)
  {
    println();
    println("Note On:");
    println("Channel:"+channel);
    println("Pitch:"+pitch);
    println("Velocity:"+velocity);
  }
}

void noteOff(int channel, int pitch, int velocity) {
  if(outputMIDI)
  {
    println();
    println("Note Off:");
    println("Channel:"+channel);
    println("Pitch:"+pitch);
    println("Velocity:"+velocity);
  }
}

void controllerChange(int channel, int number, int value)
{
  if(outputMIDI)
  {
    println("Controller Change:");
    println();
    println("Controller Change:");
    println("Channel:"+channel);
    println("Number:"+number);
    println("Value:"+value);
  }
  
  /*switch (number) {
    case 58:
      if(value > 50) programme--;
      break;
    case 59:
      if(value > 50) programme++;
      break;
  }
  
  if(programme < 1) programme = nProgrammes;
  if(programme > nProgrammes) programme = 1;
  
  println(programme);*/
  
  float normalisedValue = (float)value / 127;
  // make 64 exactly half (useful on sliders with a middle bump)
  if(value==64) normalisedValue = 0.5;
  MIDIUpdateControllable(number, normalisedValue);
}
