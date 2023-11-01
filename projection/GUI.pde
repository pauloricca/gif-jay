import controlP5.*;

Controls cf;

ControlP5 cp5;
Toggle playingToggle;
Slider centreXSlider, centreYSlider;

void setupGUI() {
  cf = new Controls(this);
}

class Controls extends PApplet {

  int w, h;
  int margin = 30;
  PApplet parent;
  ControlP5 cp5;

  public Controls(PApplet _parent) {
    super();   
    parent = _parent;
    w=1440;
    h=900;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(w, h, P3D);
  }

  public void setup() {
    surface.setLocation(0, 0);
    cp5 = new ControlP5(this);
    
    int ctrlPosX;
    int ctrlPosY;
    int ctrlPosYInc;
    
    // Audio-related sliders
    ctrlPosYInc = 30; 
    ctrlPosX = width - spectrographyWidth - margin;
    ctrlPosY = margin + spectrographyHeight + 10; 
    int audioSliderWidth = spectrographyWidth / 2 - 80;
    int sliderHeight = 22;
    
    // lowGain
    Controllable controllable = lowGain;
    controllable.slider = cp5.addSlider(controllable.name)
       .setRange(controllable.minVal, controllable.maxVal)
       .setValue(controllable.value)
       .plugTo(controllable, "value")
       .setColorBackground(color(100, 0, 0))
       .setColorForeground(color(150, 0, 0))
       .setColorActive(color(180, 0, 0))
       .setPosition(ctrlPosX, ctrlPosY)
       .setScrollSensitivity(0.1)
       .setSize(audioSliderWidth, sliderHeight);
    ctrlPosY += ctrlPosYInc;
    
    // lowBandWidth
    controllable = lowBandWidth;
    controllable.slider = cp5.addSlider(controllable.name)
       .setRange(controllable.minVal, controllable.maxVal)
       .setValue(controllable.value)
       .plugTo(controllable, "value")
       .setColorBackground(color(100, 0, 0))
       .setColorForeground(color(150, 0, 0))
       .setColorActive(color(180, 0, 0))
       .setPosition(ctrlPosX, ctrlPosY)
       .setScrollSensitivity(0.1)
       .setSize(audioSliderWidth, sliderHeight);
    ctrlPosY += ctrlPosYInc;
    
    // lowGate
    controllable = lowGate;
    controllable.slider = cp5.addSlider(controllable.name)
       .setRange(controllable.minVal, controllable.maxVal)
       .setValue(controllable.value)
       .plugTo(controllable, "value")
       .setColorBackground(color(100, 0, 0))
       .setColorForeground(color(150, 0, 0))
       .setColorActive(color(180, 0, 0))
       .setPosition(ctrlPosX, ctrlPosY)
       .setScrollSensitivity(0.1)
       .setSize(audioSliderWidth, sliderHeight);
    ctrlPosY += ctrlPosYInc;
    
    // lowSustain
    controllable = lowSustain;
    controllable.slider = cp5.addSlider(controllable.name)
       .setRange(controllable.minVal, controllable.maxVal)
       .setValue(controllable.value)
       .plugTo(controllable, "value")
       .setColorBackground(color(100, 0, 0))
       .setColorForeground(color(150, 0, 0))
       .setColorActive(color(180, 0, 0))
       .setPosition(ctrlPosX, ctrlPosY)
       .setScrollSensitivity(0.1)
       .setSize(audioSliderWidth, sliderHeight);
    ctrlPosY += ctrlPosYInc;
    
    // lowAttack
    controllable = lowAttack;
    controllable.slider = cp5.addSlider(controllable.name)
       .setRange(controllable.minVal, controllable.maxVal)
       .setValue(controllable.value)
       .plugTo(controllable, "value")
       .setColorBackground(color(100, 0, 0))
       .setColorForeground(color(150, 0, 0))
       .setColorActive(color(180, 0, 0))
       .setPosition(ctrlPosX, ctrlPosY)
       .setScrollSensitivity(0.1)
       .setSize(audioSliderWidth, sliderHeight);
    ctrlPosY += ctrlPosYInc;
    
    ctrlPosX += spectrographyWidth/2;
    ctrlPosY = margin + spectrographyHeight + 10; 
    
    // highGain
    controllable = highGain;
    controllable.slider = cp5.addSlider(controllable.name)
       .setRange(controllable.minVal, controllable.maxVal)
       .setValue(controllable.value)
       .plugTo(controllable, "value")
       .setColorBackground(color(0, 100, 0))
       .setColorForeground(color(0, 150, 0))
       .setColorActive(color(0, 180, 0))
       .setPosition(ctrlPosX, ctrlPosY)
       .setScrollSensitivity(0.1)
       .setSize(audioSliderWidth, sliderHeight);
    ctrlPosY += ctrlPosYInc;
    
    // highBandWidth
    controllable = highBandWidth;
    controllable.slider = cp5.addSlider(controllable.name)
       .setRange(controllable.minVal, controllable.maxVal)
       .setValue(controllable.value)
       .plugTo(controllable, "value")
       .setColorBackground(color(0, 100, 0))
       .setColorForeground(color(0, 150, 0))
       .setColorActive(color(0, 180, 0))
       .setPosition(ctrlPosX, ctrlPosY)
       .setScrollSensitivity(0.1)
       .setSize(audioSliderWidth, sliderHeight);
    ctrlPosY += ctrlPosYInc;
    
    // highGate
    controllable = highGate;
    controllable.slider = cp5.addSlider(controllable.name)
       .setRange(controllable.minVal, controllable.maxVal)
       .setValue(controllable.value)
       .plugTo(controllable, "value")
       .setColorBackground(color(0, 100, 0))
       .setColorForeground(color(0, 150, 0))
       .setColorActive(color(0, 180, 0))
       .setPosition(ctrlPosX, ctrlPosY)
       .setScrollSensitivity(0.1)
       .setSize(audioSliderWidth, sliderHeight);
    ctrlPosY += ctrlPosYInc;
    
    // highSustain
    controllable = highSustain;
    controllable.slider = cp5.addSlider(controllable.name)
       .setRange(controllable.minVal, controllable.maxVal)
       .setValue(controllable.value)
       .plugTo(controllable, "value")
       .setColorBackground(color(0, 100, 0))
       .setColorForeground(color(0, 150, 0))
       .setColorActive(color(0, 180, 0))
       .setPosition(ctrlPosX, ctrlPosY)
       .setScrollSensitivity(0.1)
       .setSize(audioSliderWidth, sliderHeight);
    ctrlPosY += ctrlPosYInc;
    
    // highAttack
    controllable = highAttack;
    controllable.slider = cp5.addSlider(controllable.name)
       .setRange(controllable.minVal, controllable.maxVal)
       .setValue(controllable.value)
       .plugTo(controllable, "value")
       .setColorBackground(color(0, 100, 0))
       .setColorForeground(color(0, 150, 0))
       .setColorActive(color(0, 180, 0))
       .setPosition(ctrlPosX, ctrlPosY)
       .setScrollSensitivity(0.1)
       .setSize(audioSliderWidth, sliderHeight);
    ctrlPosY += ctrlPosYInc;
    
    
    
    // Other controller sliders
    ctrlPosX = margin;
    ctrlPosY = margin;
    ctrlPosYInc = 46;
    
    for (int i = 0; i < controllables.size(); i++) {
      controllable = controllables.get(i);
      
      // ignore controllers that already have sliders
      if(controllable.slider != null) continue;
      
      // Low Toggle
      Toggle lowToggle = cp5.addToggle(controllable.name + "-low")
         .setLabelVisible(false)
         .setColorBackground(color(100, 0, 0))
         .setColorForeground(color(150, 0, 0))
         .setColorActive(color(255, 0, 0))
         .setPosition(ctrlPosX, ctrlPosY)
         .setSize(30, sliderHeight + 15)
         .setValue(false);
      controllable.lowToggle = lowToggle;
      
      // High Toggle
      Toggle highToggle = cp5.addToggle(controllable.name + "-high")
         .setLabelVisible(false)
         .setColorBackground(color(0, 100, 0))
         .setColorForeground(color(0, 150, 0))
         .setColorActive(color(0, 255, 0))
         .setPosition(ctrlPosX + 40, ctrlPosY)
         .setSize(30, sliderHeight + 15)
         .setValue(false);
      controllable.highToggle = highToggle;
      
      // Roaming Toggle
      Toggle roamingToggle = cp5.addToggle(controllable.name + "-roaming")
         .setLabelVisible(false)
         .setColorBackground(color(0, 0, 100))
         .setColorForeground(color(0, 0, 150))
         .setColorActive(color(0, 0, 255))
         .setPosition(ctrlPosX + 80, ctrlPosY)
         .setSize(30, sliderHeight + 15)
         .setValue(false);
      controllable.roamingToggle = roamingToggle;
      
      // Slider
      Slider slider = cp5.addSlider(controllable.name)
         .setRange(controllable.minVal, controllable.maxVal)
         .setValue(controllable.value)
         .plugTo(controllable, "value")
         .setPosition(ctrlPosX + 120, ctrlPosY)
         .setScrollSensitivity(0.1)
         .setSize(400, 25);
      controllable.slider = slider;
      
      // Auto Min Slider
      cp5.addSlider(controllable.name + "-auto-min")
         .setLabelVisible(false)
         .setRange(controllable.minVal, controllable.maxVal)
         .setValue(controllable.autoMinVal)
         .plugTo(controllable, "autoMinVal")
         .setScrollSensitivity(0.1)
         .setPosition(ctrlPosX + 120, ctrlPosY + 25)
         .setSize(400, 6);
      
      // Auto Max Slider
      cp5.addSlider(controllable.name + "-auto-max")
         .setLabelVisible(false)
         .setRange(controllable.minVal, controllable.maxVal)
         .setValue(controllable.autoMaxVal)
         .plugTo(controllable, "autoMaxVal")
         .setScrollSensitivity(0.1)
         .setPosition(ctrlPosX + 120, ctrlPosY + 31)
         .setSize(400, 6);
      
      ctrlPosY += ctrlPosYInc;
    }  
  }
  
  /*void controlEvent(ControlEvent theEvent) {
    for (int i = 0; i < controllables.size(); i++) {
      Controllable controllable = controllables.get(i);
      if (controllable.slider == theEvent.getController()) {
        //if(controllable.lowToggle != null) controllable.lowToggle.setState(false); 
      }
      //if(controllable.lowToggle != null)
    }
  }*/

  void draw() {
    pushStyle();
    background(70);
    
    // Spectrograph
    drawSpectrograph(this, width - spectrographyWidth - margin, margin);
    
    // Preview window
    if (showPreview) {
      int previewWidth = 700;
      int previewHeight = int(previewWidth * _height / _width);
      try {
        if (preview != null) image(preview, width - margin - previewWidth, height - margin - previewHeight, previewWidth, previewHeight);
      } catch (Exception e) {println(e);}
    }
    
    /*int previewWidth = 700;
    int previewHeight = int(previewWidth * _height / _width);
    previewPG.beginDraw();
    previewPG.shader(shader);
    previewPG.rect(0, 0, previewPG.width, previewPG.height);
    previewPG.endDraw();  
    image(previewPG, width - margin - previewWidth, height - margin - previewHeight, previewWidth, previewHeight);*/
    
    // Frame rate
    fill(255, 255, 255);
    textSize(12);
    text(frame_rate, width - 70, 20);
    
    popStyle();
    
    animateRoamingControllers();
  }
  
  void keyPressed() {
    keyboardPressed(key);
  }
  
  void mousePressed() {
    mouseIsDown = true;
  }
  
  void mouseReleased() {
    mouseIsDown = false;
  }
}
