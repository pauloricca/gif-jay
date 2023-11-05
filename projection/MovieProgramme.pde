// Needs Processing video v4 library installed
import processing.video.*;
import java.io.File;

public class MovieProgramme implements Programme {
  private PApplet pApplet;
  private float changeEvery = 2; // In seconds

  private ArrayList<Movie> movies = new ArrayList<Movie>();
  private Movie currentMovie;
  
  private int currentMovieIndex = 0;
  private int lastChange = millis();
  
  public MovieProgramme(PApplet pApplet) {
    this.pApplet = pApplet;
  }
  
  public void draw(PGraphics pg, float strength) {
    if (movies.size() == 0) return;
  
    int currentTime = millis();
    if (lastChange + (changeEvery * 1000) < currentTime) {
      currentMovie.stop();
      currentMovieIndex = (currentMovieIndex + 1) % movies.size();
      currentMovie = movies.get(currentMovieIndex);
      currentMovie.jump(0);
      currentMovie.loop();
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
      movies.clear();
      currentMovieIndex = 0;
      
      for(int i = 0; i < fileNames.length; i++)
      {
        if (fileNames[i].endsWith(".mp4")) {
          println("loading video " + dirName + '/' + fileNames[i]);
          Movie movie;
          movie = new Movie(this.pApplet, dirName + '/' + fileNames[i]);
          movie.play();
          movies.add(movie);
        }
      }
      
      if (movies.size() > 0) currentMovie = movies.get(0);
    } catch (Exception e) {
      println("Error loading directory " + dirName);
    }
  }
}
