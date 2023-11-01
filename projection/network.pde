import processing.net.*;

int port = 10002;
Server myServer;

void initServer() {
  myServer = new Server(this, port);
  movieProgramme.loadDir("synthwave");
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
       movieProgramme.loadDir(lastLine);
     }
  }
}
