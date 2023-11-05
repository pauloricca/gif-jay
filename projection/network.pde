import oscP5.*;
import netP5.*;

OscP5 oscP5;

int port = 10002;

void initServer() {
  oscP5 = new OscP5(this, port);
  movieProgramme.loadDir("synthwave");
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message.");
  println(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  
  if(theOscMessage.checkAddrPattern("/play") == true && theOscMessage.checkTypetag("s")) {
    if(theOscMessage.checkTypetag("s")) {
      movieProgramme.loadDir(theOscMessage.get(0).stringValue());
    }  
  } 
}
