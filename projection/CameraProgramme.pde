import processing.video.*;

public class CameraProgramme implements Programme {
  private Capture cam;
  
  public CameraProgramme(PApplet pApplet) {
    String[] cameras = Capture.list();
    for(int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // Use the second camera if available, otherwise use the first one
    if (cameras.length > 0) {
      // To go around a bug with the usb camera, otherwise we would have gone with cameras[cameras.length - 1]
      // We need to start OBS with a virtual camera for this to work
      String cameraChoice = "OBS Virtual Camera";
      this.cam = new Capture(pApplet, cameraChoice);
      this.cam.start();
    }
  }

  public void draw(PGraphics pg, float strength) {
    if (cam == null) return;
 
    if (cam.available() == true) {
      cam.read();
    }
    
    float movieSizeRatio = float(cam.width) / float(cam.height);
    float screenSizeRatio = float(base.width) / float(base.height);
    float renderHeight;
    float renderWidth;
    
    if (movieSizeRatio > screenSizeRatio) {
       renderHeight = float(base.height);
       renderWidth = renderHeight * movieSizeRatio;
    } else {
      renderWidth = float(base.width);
      renderHeight = renderWidth * float(cam.height) / float(cam.width);
    }
    
    if (strength < 1) pg.tint(255, strength * 255);
   
    pg.image(cam,
          - (renderWidth - float(base.width)) / 2,
          - (renderHeight - float(base.height)) / 2, 
          renderWidth,
          renderHeight
    );
  }
}
