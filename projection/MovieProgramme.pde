// Needs Processing video v4 library installed
import processing.video.*;
import java.io.File;
import java.util.Arrays;

void movieEvent(Movie m) {
  m.read();
}

public class MovieProgramme implements Programme {
  private PApplet pApplet;

  private ArrayList<String> moviePaths = new ArrayList<String>();
  private Movie currentMovie;
  private Movie nextMovie;
  
  private int nextMovieIndex = 0;
  private int lastChange = millis();
  private int lastRestart = millis();
  
  // As oppose to "Fill" as in the whole frame will fit the screen instead of filling it (we're checking for file names ending in "-fit.*") 
  private boolean isCurrentMovieFit = false;
  private boolean isNextMovieFit = false;
  
  public MovieProgramme(PApplet pApplet) {
    this.pApplet = pApplet;
  }
  
  private void changeMovie() {
    currentMovie.stop();
    isCurrentMovieFit = isNextMovieFit;
    currentMovie = nextMovie;
    currentMovie.jump(startingPoint.val() * currentMovie.duration());
    currentMovie.play();
    currentMovie.loop();
    nextMovieIndex = (nextMovieIndex + 1) % moviePaths.size();
    String nextMoviePath = moviePaths.get(nextMovieIndex);
    nextMovie = new Movie(this.pApplet, nextMoviePath);
    nextMovie.play();
 
    if (nextMoviePath.endsWith("-fit.mov") || nextMoviePath.endsWith("-fit.mp4")) isNextMovieFit = true;
    else isNextMovieFit = false;
  }
  
  public void draw(PGraphics pg, float strength) {
    if (moviePaths.size() == 0) return;
  
    int currentTime = millis();

    if (lastChange + (maxChangeTime.val() * 1000) < currentTime && moviePaths.size() > 1) {
      changeMovie();
      lastChange = currentTime;
    }
    
    if (changeMovieController.val() > 0.5 && lastChange + (minChangeTime.val() * 1000) < currentTime) {
      changeMovie();
      lastChange = currentTime;
    }
    
    if (restartEvery.val() > 0 && lastRestart + (restartEvery.val() * 1000) < currentTime) {
      currentMovie.jump(startingPoint.val() * currentMovie.duration());
      lastRestart = currentTime;
    }
    
    if (restartMovieController.val() > 0.5 && lastRestart + (minRestartTime.val() * 1000) < currentTime) {
      currentMovie.jump(startingPoint.val() * currentMovie.duration());
      lastRestart = currentTime;
    }

    float movieSizeRatio = float(currentMovie.width) / float(currentMovie.height);
    float screenSizeRatio = float(base.width) / float(base.height);
    float renderHeight;
    float renderWidth;
    
    if (movieSizeRatio > screenSizeRatio && !isCurrentMovieFit || movieSizeRatio < screenSizeRatio && isCurrentMovieFit) {
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
      java.io.File folder = new java.io.File(dataPath("galleries/" + dirName));
      String[] fileNames = folder.list();
      Arrays.sort(fileNames);
      ArrayList<String> newMoviePaths = new ArrayList<String>();
      
      for(int i = 0; i < fileNames.length; i++)
      {
        if (fileNames[i].endsWith(".mp4") || fileNames[i].endsWith(".mov")) {
          newMoviePaths.add("galleries/" + dirName + '/' + fileNames[i]);
        }
      }
      
      if (newMoviePaths.size() > 0) {
        currentMovie = new Movie(this.pApplet, newMoviePaths.get(0));
        currentMovie.play();
        currentMovie.jump(startingPoint.val() * currentMovie.duration());
        currentMovie.loop();
        if (newMoviePaths.size() > 1) {
          nextMovieIndex = 1;
        } else {
          nextMovieIndex = 0;
        }
        nextMovie = new Movie(this.pApplet, newMoviePaths.get(nextMovieIndex));
        nextMovie.play();
        moviePaths = newMoviePaths;
      }
    } catch (Exception e) {
      println("Error loading directory " + dirName);
    }
  }
}
