import processing.net.*;

int port = 10002;
Server myServer;

void initServer() {
  myServer = new Server(this, port);
  loadDir("a");
}

void checkServer() {
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
    movies.clear();
    currentMovieIndex = 0;
    
    for(int i = 0; i < fileNames.length; i++)
    {
      if (fileNames[i].endsWith(".mp4")) {
        println("loading video " + dirName + '/' + fileNames[i]);
        Movie movie;
        movie = new Movie(this, dirName + '/' + fileNames[i]);
        movie.play();
        movies.add(movie);
      }
    }
    
    if (movies.size() > 0) currentMovie = movies.get(0);
  } catch (Exception e) {
    println("Error loading directory " + dirName);
  }
}
