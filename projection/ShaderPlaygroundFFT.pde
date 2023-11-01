PShader shader;
PShader postFXShader;
PGraphics pg;
PGraphics base;
int shaderLoadTimer = 0;
int shaderLoadEvery = 100;
float frame_rate = 0;
float _width = 0;
float _height = 0;
PImage preview = null;
PGraphics previewPG;
int previewScreenshotEvery = 0;
//boolean savedPreview = false;
boolean mouseIsDown = false;
float time = 0;

boolean useMidiController = false;
boolean isFullscreen = false;
boolean doPostFX = true;
boolean showPreview = true;
boolean liveShaders = true;

ArrayList<Controllable> controllables = null;

Controllable lowGain = new Controllable("low gain", 0.2, 0, 100, 16);
Controllable lowBandWidth = new Controllable("low band width", 10, 5, 100);
Controllable lowGate = new Controllable("low gate", 0, 0, 1);
Controllable lowSustain = new Controllable("low sustain", 0.92, 0, 1, 0);
Controllable lowAttack = new Controllable("low attack", 1, 0, 1);
Controllable highGain = new Controllable("high gain", 0.2, 0, 100, 16);
Controllable highBandWidth = new Controllable("high band width", 10, 5, 100);
Controllable highGate = new Controllable("high gate", 0, 0, 1);
Controllable highSustain = new Controllable("high sustain", 0.92, 0, 1, 0);
Controllable highAttack = new Controllable("high attack", 1, 0, 1);

Controllable timeIncrement = new Controllable("time increment", 0.3, 0, 3);
Controllable roamingSpeed = new Controllable("roaming speed", 0.01, 0, 0.2);

Controllable hue = new Controllable("hue", 0.5, 0, 1, 21);
Controllable saturation = new Controllable("saturation", 0, 0, 1, 22);
Controllable brightness = new Controllable("brightness", 1, 0, 1, 23);
Controllable backgroundHue = new Controllable("background hue", 0.5, 0, 1);
Controllable backgroundSaturation = new Controllable("background saturation", 0, 0, 1);
Controllable backgroundBrightness = new Controllable("background brightness", 0, 0, 1);


Controllable p1 = new Controllable("p1 chromaticAberration", 0.02, 0, 1, 17);
Controllable p2 = new Controllable("p2 scale x", 0.7, 0, 1, 18);
Controllable p3 = new Controllable("p3 flow x", 0.05, 0, 1, 19);
Controllable p4 = new Controllable("p4 distortion", 0, 0, 1, 20);

Controllable p5 = new Controllable("p5 octaves", 0.5, 0, 1, 1);
Controllable p6 = new Controllable("p6 scale y", 0.5, 0, 1, 2);
Controllable p7 = new Controllable("p7 flow y", 0.1, 0, 1, 3);
Controllable p8 = new Controllable("p8 octave falloff", 0.95, 0, 1, 4);

Controllable baseStrength = new Controllable("base strength", 0.5, 0, 1);
Controllable postFXStrength = new Controllable("post fx", 0.5, 0, 1);


ArrayList<Programme> programmes = new ArrayList<Programme>();
Programme currentProgramme;
Programme previousProgramme;
float previousProgrammeMultiplier = 0;
float currentProgrammeMultiplier = 1;
float programmeFadeSpeed = 0.03;

String currentShader = "noise"; 
String currentPostFXShader = "bloom"; 

void setup_2() {
  //if(isFullscreen) fullScreen(P3D, 2);
  //else 
  size(600, 400, P3D); 

  programmes.add(currentProgramme = new CircleProgramme(true, 1, false));
  programmes.add(new CircleProgramme(false, 1, false));
  programmes.add(new CircleProgramme(false, 4, false));
  programmes.add(new CircleProgramme(false, 5, true));
  programmes.add(new ArcProgramme(false, 30));
  programmes.add(new ArcProgramme(false, 80));
  programmes.add(new HorizonProgramme());
  programmes.add(new BarsProgramme(5));
  programmes.add(new CubeProgramme());
  programmes.add(new ImageProgramme(loadImage("water1.jpg")));
  programmes.add(new ImageProgramme(loadImage("water2.jpg")));
  programmes.add(new ImageProgramme(loadImage("water3.jpg")));
  programmes.add(new ImageProgramme(loadImage("water4.jpg")));
  
  noCursor();
  pixelDensity(1);
  pg = createGraphics(width, height, P3D);
  base = createGraphics(width, height, P3D);
  base.beginDraw(); base.background(0); base.endDraw();
  pg.noSmooth();   
  if(useMidiController) initMIDI();
  setupGUI();
  setupAudio();
  loadShaders();
  _width = width;
  _height = height;
  preview = new PImage(width, height);
  previewPG = createGraphics(width/8, height/8, P3D);
}

void loadShaders() {
  shader = loadShader(currentShader + ".glsl");
  shader.set("resolution", float(pg.width), float(pg.height));
  postFXShader = loadShader(currentPostFXShader + ".glsl");
  postFXShader.set("resolution", float(pg.width), float(pg.height));
}

void updateShaders() {
  shader.set("time", time);
  shader.set("p1", p1.val());
  shader.set("p2", p2.val());
  shader.set("p3", p3.val());
  shader.set("p4", p4.val());
  shader.set("p5", p5.val());
  shader.set("p6", p6.val());
  shader.set("p7", p7.val());
  shader.set("p8", p8.val()); 
  shader.set("srcTex", base);
  postFXShader.set("time", time);
  postFXShader.set("strength", postFXStrength.val());
}

void draw_2() {
  try {
    time += timeIncrement.val() * (1/frameRate);
    if(liveShaders && shaderLoadTimer < 0) { loadShaders(); shaderLoadTimer = shaderLoadEvery; }
    shaderLoadTimer--;
    
    updateShaders();
    drawBase();
    
    pg.beginDraw();
    //pg.background(0);
    pg.shader(shader);
    pg.rect(0, 0, pg.width, pg.height);
    pg.endDraw();  
    
    postFXShader.set("srcTex", pg);
    if (doPostFX && postFXStrength.val() > 0) shader(postFXShader);
    else resetShader();
    image(pg, 0, 0, width, height);
    
    if (showPreview) {
      if (previewScreenshotEvery<0) {
        //preview.copy(pg.get(), 0, 0, width, height, 0, 0, width, height);
        pg.loadPixels();
        //preview.loadPixels();
        for (int i = 0; i < pg.width*pg.height; i++) {
          preview.pixels[i] = pg.pixels[i];
        }
        preview.updatePixels();
        previewScreenshotEvery = isFullscreen ? 10 : 0 ;
      }
      
      previewScreenshotEvery--;
    }
    
    //println(frameRate);
    frame_rate = frameRate;
  } catch (Exception e) {println(e);}
}

// Draw the base image that will be passed to the shader
void drawBase() {
  base.beginDraw();
  base.colorMode(HSB, 1);
  base.fill(hue.val(), saturation.val(), brightness.val());
  base.stroke(hue.val(), saturation.val(), brightness.val());
  base.background(backgroundHue.val(), backgroundSaturation.val(), backgroundBrightness.val(), 0.001);
  base.colorMode(RGB, 255);
  
  if(previousProgrammeMultiplier > 0) {
    previousProgrammeMultiplier -= programmeFadeSpeed;
    
    base.pushStyle();
    base.pushMatrix();
    previousProgramme.draw(base, baseStrength.val() * previousProgrammeMultiplier);
    base.popMatrix();
    base.popStyle();
  }
  
  if(currentProgrammeMultiplier < 1) currentProgrammeMultiplier += programmeFadeSpeed;
  else currentProgrammeMultiplier = 1;
  
  base.pushStyle();
  base.pushMatrix();
  currentProgramme.draw(base, baseStrength.val() * currentProgrammeMultiplier);
  base.popMatrix();
  base.popStyle();
  
  base.endDraw(); 
}

void setProgramme(Programme programme) {
  if (currentProgramme == programme) return;
  
  previousProgramme = currentProgramme;
  currentProgramme = programme;
  previousProgrammeMultiplier = 1;
  currentProgrammeMultiplier = 0;
}
