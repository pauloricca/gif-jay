// Needs Processing video v4 library installed
import processing.video.*;
import java.io.File;

void movieEvent(Movie m) {
  m.read();
}

public class MovieProgramme implements Programme {
  private PApplet pApplet;
  private float changeEvery = 2; // In seconds

  private ArrayList<String> moviePaths = new ArrayList<String>();
  private Movie currentMovie;
  private Movie nextMovie;
  
  private int currentMovieIndex = 0;
  private int lastChange = millis();
  
  public MovieProgramme(PApplet pApplet) {
    this.pApplet = pApplet;
  }
  
  public void draw(PGraphics pg, float strength) {
    if (moviePaths.size() == 0) return;
  
    int currentTime = millis();
    if (lastChange + (changeEvery * 1000) < currentTime && moviePaths.size() > 1) {
      currentMovie.stop();
      currentMovie = nextMovie;
      currentMovie.jump(0);
      currentMovie.play();
      currentMovie.loop();
      currentMovieIndex = (currentMovieIndex + 1) % moviePaths.size();
      nextMovie = new Movie(this.pApplet, moviePaths.get(currentMovieIndex));
      nextMovie.play();
      lastChange = currentTime;
    }
    
    float movieSizeRatio = float(currentMovie.width) / float(currentMovie.height);
    float screenSizeRatio = float(base.width) / float(base.height);
    float renderHeight = 0;
    float renderWidth = 0;
    
    if (movieSizeRatio > screenSizeRatio) {
       renderHeight = float(base.height);
       renderWidth = renderHeight * movieSizeRatio;
    } else {
      renderWidth = float(base.width);
      renderHeight = renderWidth * float(currentMovie.height) / float(currentMovie.width);
    }
    
    if (strength < 1) pg.tint(255, strength * 255);
    
    // Rendering next movie makes the movie ready for playing straightaway without a dark frame in between loads
    pg.image(nextMovie, 0, 0, 1, 1);
   
    pg.image(currentMovie,
          - (renderWidth - float(base.width)) / 2,
          - (renderHeight - float(base.height)) / 2, 
          renderWidth,
          renderHeight
    );
  }
  
  void loadDir(String dirName)
  {
    try {
      println("Loading directory " + dirName);
      java.io.File folder = new java.io.File(dataPath(dirName));
      String[] fileNames = folder.list();
      moviePaths.clear();
      currentMovieIndex = 0;
      
      for(int i = 0; i < fileNames.length; i++)
      {
        if (fileNames[i].endsWith(".mp4")) {
          println("loading video " + dirName + '/' + fileNames[i]);
          moviePaths.add(dirName + '/' + fileNames[i]);
        }
      }
      
      if (moviePaths.size() > 0) {
        currentMovie = new Movie(this.pApplet, moviePaths.get(0));
        currentMovie.play();
        currentMovie.loop();
        if (moviePaths.size() > 1) {
          nextMovie = new Movie(this.pApplet, moviePaths.get(1));
          nextMovie.play();
        }
      }
    } catch (Exception e) {
      println("Error loading directory " + dirName);
    }
  }
}
