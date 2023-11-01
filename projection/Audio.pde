import processing.sound.*;

FFT fft;
AudioIn audioIn;
int bands = 512;
float[] spectrum = new float[bands];

int lowBand = 20;
int highBand = 400;
int spectrographyWidth = 512;
int spectrographyHeight = 200;

boolean audioInitialised = false;

PGraphics sPG;

float volLow = 0;
float volHigh = 0;

void setupAudio() {
  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  audioIn = new AudioIn(this, 0);
  
  // start the Audio Input
  audioIn.start();
  
  // patch the AudioIn
  fft.input(audioIn);
  
  sPG = createGraphics(spectrographyWidth, spectrographyHeight);
  
  audioInitialised = true;
}

void drawSpectrograph(PApplet window, int px, int py) {
  if (!audioInitialised) return;
  
  fft.analyze(spectrum);
  sPG.beginDraw();
  sPG.background(0);
  
  
  float spectrumAmplitude = 100;
  
  // draw spectrum
  sPG.stroke(255);
  float lowBandMax = 0;
  float highBandMax = 0;
  for(int i = 0; i < bands; i++){
    // The result of the FFT is normalized
    // draw the line for frequency band i scaling it up by 5 to get more amplitude.
    float bandVolume = spectrum[i];
    sPG.line(i, sPG.height, i, sPG.height - bandVolume * spectrumAmplitude * sPG.height );
    if (i >= lowBand - (lowBandWidth.val() / 2) && i <= lowBand + (lowBandWidth.val() / 2) && bandVolume > lowBandMax) lowBandMax = bandVolume;
    if (i >= highBand - (highBandWidth.val() / 2) && i <= highBand + (highBandWidth.val() / 2) && bandVolume > highBandMax) highBandMax = bandVolume;
  }
  
  // multiply by gain and limit to 1
  lowBandMax *= lowGain.val();
  highBandMax *= highGain.val();
  if (lowBandMax > 1) lowBandMax = 1;
  if (highBandMax > 1) highBandMax = 1;
  
  // apply gate
  if(lowGate.val() == 1) { // 1 would cause a NaN
    lowBandMax = 0;
  } else {
    lowBandMax -= lowGate.val(); if (lowBandMax < 0) lowBandMax = 0;
    lowBandMax = map(lowBandMax, 0, 1 - lowGate.val(), 0, 1);
  }
  if(highGate.val() == 1) {
    highBandMax = 0;
  } else {
    highBandMax -= highGate.val(); if (highBandMax < 0) highBandMax = 0;
    highBandMax = map(highBandMax, 0, 1 - highGate.val(), 0, 1);
  }
  
  // apply attack and sustain
  if (lowBandMax < volLow) volLow = volLow * lowSustain.val() + (1-lowSustain.val()) * lowBandMax;
  else volLow = lowBandMax * lowAttack.val() + (1-lowAttack.val()) * volLow;
  if (highBandMax < volHigh) volHigh = volHigh * highSustain.val() + (1-highSustain.val()) * highBandMax;
  else volHigh = highBandMax * highAttack.val() + (1-highAttack.val()) * volHigh;

  sPG.noStroke();
  
  // Selected bands
  sPG.fill(255, 0, 0, 150);
  sPG.rect(lowBand - (lowBandWidth.val() / 2), 0, lowBandWidth.val(), sPG.height * (1 - lowGate.val()));
  sPG.fill(0, 255, 0, 150);
  sPG.rect(highBand - (highBandWidth.val() / 2), 0, highBandWidth.val(), sPG.height * (1 - highGate.val()));
  sPG.fill(255, 255, 0, 100);
  sPG.rect(window.mouseX - px - (lowBandWidth.val() / 2), 0, lowBandWidth.val(), sPG.height);
  
  // Band monitors
  sPG.fill(255, 0, 0, 150);
  sPG.rect(lowBand - (lowBandWidth.val() / 2), sPG.height - sPG.height * lowGate.val(), lowBandWidth.val(), -sPG.height * volLow * (1 - lowGate.val()));
  sPG.fill(0, 255, 0, 150);
  sPG.rect(highBand - (highBandWidth.val() / 2), sPG.height - sPG.height * highGate.val(), highBandWidth.val(), -sPG.height * volHigh * (1 - highGate.val()));
  sPG.fill(255, 255, 0, 100);
  
  // Control select band if we're clicking on the spectrograph
  if (mouseIsDown && window.mouseX > px && window.mouseX < px + sPG.width && window.mouseY > py && window.mouseY < py + sPG.height) {
    if (window.mouseButton == LEFT) lowBand = window.mouseX - px;
    if (window.mouseButton == RIGHT) highBand = window.mouseX - px;
  }
  
  // Set controllers whose value is linked to audio
  for (int i = 0; i < controllables.size(); i++) {
    Controllable controllable = controllables.get(i);
    if (controllable.lowToggle != null && controllable.lowToggle.getState()) {
      controllable.val(map(constrain(volLow, 0, 1), 0, 1, controllable.autoMinVal, controllable.autoMaxVal));
    }
    if (controllable.highToggle != null && controllable.highToggle.getState()) {
      controllable.val(map(constrain(volHigh, 0, 1), 0, 1, controllable.autoMinVal, controllable.autoMaxVal));
    }
  }
  
  sPG.endDraw(); 
  
  window.image(sPG, px, py);
}
