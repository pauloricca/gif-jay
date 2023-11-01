// Needs Processing video v4 library installed

import java.io.File;
import processing.video.*;

float changeEvery = 2; // In seconds

ArrayList<Movie> movies = new ArrayList<Movie>();
Movie currentMovie;

int currentMovieIndex = 0;
int lastChange = millis();

void setup()
{
  //fullScreen();
  //noCursor();
  size(400, 400);
  background(0);
  frameRate(25);
  
  initServer();
}

void draw()
{
  background(0);
  checkServer();
  if (movies.size() == 0) return;
  
  int currentTime = millis();
  if (lastChange + (changeEvery * 1000) < currentTime) {
    currentMovie.stop();
    currentMovieIndex = (currentMovieIndex + 1) % movies.size();
    currentMovie = movies.get(currentMovieIndex);
    currentMovie.jump(0);
    currentMovie.loop();
    println("playing " + currentMovieIndex);
    lastChange = currentTime;
  }
  
  float movieSizeRatio = float(currentMovie.width) / float(currentMovie.height);
  float screenSizeRatio = float(width) / float(height);
  float renderHeight = 0;
  float renderWidth = 0;
  
  if (movieSizeRatio > screenSizeRatio) {
     renderHeight = float(height);
     renderWidth = renderHeight * movieSizeRatio;
  } else {
    renderWidth = float(width);
    renderHeight = renderWidth * float(currentMovie.height) / float(currentMovie.width);
  }
 
  image(currentMovie,
        - (renderWidth - float(width)) / 2,
        - (renderHeight - float(height)) / 2, 
        renderWidth,
        renderHeight
   );
}

void movieEvent(Movie m) {
  m.read();
}


  
