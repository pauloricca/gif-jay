PShader colourShader;
PShader mainShader;
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
PGraphics maskPG = null;
int previewScreenshotEvery = 0;
boolean mouseIsDown = false;
float time = 0;

boolean useMidiController = false;
boolean isFullscreen = true;
boolean showPreview = true;
boolean doPostFX = true;
boolean liveShaders = true;
boolean useCamera = false;

String[] galleries = {"night vision", "falling"};
int currentGalleryIndex = 0;

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


Controllable p1 = new Controllable("p1 chromaticAberration", 0.02, 0, 0.3, 17);
Controllable p2 = new Controllable("p2 scale x", 0.7, 0, 1, 18);
Controllable p3 = new Controllable("p3 flow x", 0.05, 0, 1, 19);
Controllable p4 = new Controllable("p4 distortion", 0, 0, 1, 20);

Controllable p5 = new Controllable("p5 octaves", 0.2, 0, 1, 1);
Controllable p6 = new Controllable("p6 scale y", 0.5, 0, 1, 2);
Controllable p7 = new Controllable("p7 flow y", 0.1, 0, 1, 3);
Controllable p8 = new Controllable("p8 octave falloff", 0.95, 0, 1, 4);

Controllable baseStrength = new Controllable("base strength", 1, 0, 1);
Controllable postFXStrength = new Controllable("post fx", 0.5, 0, 1);

Controllable minChangeTime = new Controllable("min change time", 0.5, 0.01, 3); // minimum interval between movie changes
Controllable maxChangeTime = new Controllable("max change time", 2, 0.01, 6); // maximum interval between movie changes
Controllable restartEvery = new Controllable("restart every", 6, 0, 6); // restarts movie every. 0 means don't restart before the end.
Controllable startingPoint = new Controllable("starting point", 0, 0, 1); // starting point of the movie, from 0 to 1
Controllable changeMovieController = new Controllable("change movie", 0, 0, 1); // changes movie when value > 0.5
Controllable restartMovieController = new Controllable("restart movie", 0, 0, 1); // restarts movie when value > 0.5
Controllable minRestartTime = new Controllable("min restart time", 0.1, 0.01, 2); // minimum interval between movie restarts
Controllable galleryIndex = new Controllable("gallery", currentGalleryIndex, 0, galleries.length); // gallery index to display

MovieProgramme movieProgramme;

ArrayList<Programme> programmes = new ArrayList<Programme>();
Programme currentProgramme;
Programme previousProgramme;
float previousProgrammeMultiplier = 0;
float currentProgrammeMultiplier = 1;
float programmeFadeSpeed = 0.03;

String currentMainShaderName = "noise"; 
String currentColourShaderName = null;
String currentPostFXShaderName = "bloom"; 
String currentMaskFileName = null;
boolean loadNewMask = false;

void setup() {
  fullScreen(P3D, 2); 
  //size(600, 400, P3D); 
  
  movieProgramme = new MovieProgramme(this);
  movieProgramme.loadDir(galleries[currentGalleryIndex]);

  programmes.add(movieProgramme);
  if (useCamera) programmes.add(new CameraProgramme(this));
  programmes.add(new BandsProgramme(6));
  programmes.add(new CircleProgramme(true, 1, false, false, false));
  programmes.add(new CircleProgramme(false, 1, false, false, false));
  programmes.add(new CircleProgramme(false, 4, false, false, false));
  programmes.add(new CircleProgramme(false, 12, false, true, true));
  programmes.add(new CircleProgramme(false, 5, true, true, true));
  programmes.add(new ArcProgramme(false, 30));
  programmes.add(new ArcProgramme(false, 80));
  programmes.add(new HorizonProgramme());
  programmes.add(new BarsProgramme(5));
  programmes.add(new CubeProgramme());
  
  currentProgramme = movieProgramme;
  
  initServer();
  
  pixelDensity(1);
  pg = createGraphics(width, height, P3D);
  base = createGraphics(width, height, P3D);
  base.beginDraw(); base.background(0); base.endDraw();
  pg.noSmooth();   
  if(useMidiController) initMIDI();
  setupGUI();
  setupAudio();
  _width = width;
  _height = height;
  preview = new PImage(width, height);
  previewPG = createGraphics(width/8, height/8, P3D);
  
  loadSettings();
  loadShaders();
}

void loadShaders() {
  try {
    if (currentColourShaderName == null) colourShader = null;
    else colourShader = loadShader("shaders/" + currentColourShaderName + ".glsl");
    mainShader = loadShader("shaders/" + currentMainShaderName + ".glsl");
    mainShader.set("resolution", float(pg.width), float(pg.height));
    postFXShader = loadShader("shaders/" + currentPostFXShaderName + ".glsl");
    postFXShader.set("resolution", float(pg.width), float(pg.height));
  } catch (Exception e) {println("Error loading shaders");}
}

void updateShaders() {
  if (colourShader != null) colourShader.set("time", time);
  mainShader.set("time", time);
  mainShader.set("p1", p1.val());
  mainShader.set("p2", p2.val());
  mainShader.set("p3", p3.val());
  mainShader.set("p4", p4.val());
  mainShader.set("p5", p5.val());
  mainShader.set("p6", p6.val());
  mainShader.set("p7", p7.val());
  mainShader.set("p8", p8.val()); 
  mainShader.set("srcTex", base);
  postFXShader.set("time", time);
  postFXShader.set("strength", postFXStrength.val());
}

void draw() {
  if ( currentProgramme == movieProgramme && currentGalleryIndex != min(floor(galleryIndex.val()), galleries.length - 1) ) {
    currentGalleryIndex = min(floor(galleryIndex.val()), galleries.length - 1);
    movieProgramme.loadDir(galleries[currentGalleryIndex]);
  }

  try {
    if (loadNewMask) {
      if (currentMaskFileName != null) {
        loadMask(currentMaskFileName);
      } else {
        maskPG = null;
      }
      loadNewMask = false;
    }
    
    time += timeIncrement.val() * (1/frameRate);
    
    if(liveShaders && shaderLoadTimer < 0) { loadShaders(); shaderLoadTimer = shaderLoadEvery; }
    shaderLoadTimer--;
    
    drawBase();
    
    if (colourShader != null) base.filter(colourShader);
    
    updateShaders();
    
    pg.beginDraw();
    pg.shader(mainShader);
    pg.rect(0, 0, pg.width, pg.height);
    pg.endDraw();  
    
    if (doPostFX && postFXStrength.val() > 0) pg.filter(postFXShader);
    
    image(pg, 0, 0, width, height);
    
    if (maskPG != null) {
      // For some reason the resulting maskPG always has a shade of white, so are having to use MULTIPLY blend mode here
      pushStyle();
      blendMode(MULTIPLY);
      image(maskPG, 0, 0);
      popStyle();
    }
 
    
    if (showPreview) {
      if (previewScreenshotEvery<0) {
        pg.loadPixels();
        for (int i = 0; i < pg.width*pg.height; i++) {
          preview.pixels[i] = pg.pixels[i];
        }
        preview.updatePixels();
        previewScreenshotEvery = isFullscreen ? 10 : 0 ;
      }
      
      previewScreenshotEvery--;
    }
    
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

// Draws a black masked image onto maskPG, with pre-calculated transparency
void loadMask(String fileName) {
  if (fileName == null || fileName == "") {
    maskPG = null;
  } else {
    PImage maskImage = loadImage("masks/" + fileName);
    maskPG = createGraphics(width, height, P3D);
    PGraphics maskImagePG = createGraphics(width, height, P3D);
    PGraphics maskedRectPG = createGraphics(width, height, P3D);
    
    float imageSizeRatio = float(maskImage.width) / float(maskImage.height);
    float targetSizeRatio = float(maskPG.width) / float(maskPG.height);
    float targetHeight;
    float targetWidth;
    
    if (imageSizeRatio < targetSizeRatio) {
       targetHeight = float(maskPG.height);
       targetWidth = targetHeight * imageSizeRatio;
    } else {
      targetWidth = float(maskPG.width);
      targetHeight = targetWidth * float(maskImage.height) / float(maskImage.width);
    }
    
    maskImagePG.beginDraw();
    maskImagePG.background(255);
    maskImagePG.image(maskImage,
      - (targetWidth - float(maskPG.width)) / 2,
      - (targetHeight - float(maskPG.height)) / 2, 
      targetWidth,
      targetHeight
    );
    maskImagePG.filter(INVERT);
    maskImagePG.endDraw();
    
    // Strangely the images were getting a bit darker when using the .mask method below, so this works as well since we're blending it anyway
    maskPG = maskImagePG;
    
    //maskedRectPG.beginDraw();
    //maskedRectPG.background(0);
    //maskedRectPG.endDraw();
    //maskedRectPG.mask(maskImagePG);
    
    //maskPG.beginDraw();
    //maskPG.image(maskedRectPG, 0, 0);
    //maskPG.endDraw();
  }
}
  
