import processing.net.*;
import java.io.File;
import gifAnimation.*;

int port = 10002;
Server myServer;

ArrayList<PImage[]> gifs = new ArrayList<PImage[]>();

int currentGif = 0;
int currentFrame = 0;

void setup()
{
  size(400, 400);
  background(0);
  myServer = new Server(this, port);
  frameRate(25);
  
  loadDir("a");
}

void draw()
{
  background(0);
  checkServer();
  if (gifs.size() == 0) return;
 
  if (currentGif < gifs.size() && currentFrame < gifs.get(currentGif).length)
  {
    image(gifs.get(currentGif)[currentFrame], 0, 0);
    currentFrame++;
  }
  if (currentFrame >= gifs.get(currentGif).length)
  {
    currentFrame = 0;
    currentGif++;
  }
  if (currentGif >= gifs.size())
  {
    currentGif = 0;
  }
}

void checkServer()
{
  // Get the next available client
  Client thisClient = myServer.available();
  // If the client is not null, and says something, display what it said
  if (thisClient != null) {
     println("Request received");
     String requestBody = thisClient.readString();
     if (requestBody != null)
     {
       String[] requestBodyLines = requestBody.split(System.lineSeparator());
       String lastLine = requestBodyLines[requestBodyLines.length - 1];
       loadDir(lastLine);
     }
  }
}

void loadDir(String dirName)
{
  try {
    println("Loading directory " + dirName);
    java.io.File folder = new java.io.File(dataPath(dirName));
    String[] fileNames = folder.list();
    gifs.clear();
    currentGif = 0;
    currentFrame = 0;
    for(int i = 0; i < fileNames.length; i++)
    {
      println("loading gif " + dataPath(dirName + '/' + fileNames[i]));
      PImage[] gif = Gif.getPImages(this, dataPath(dirName + '/' + fileNames[i]));
      println(gif.length + " frames");
      gifs.add(gif);
    }
  } catch (Exception e) {
    println("Error loading directory " + dirName);
  }
}
  
