import oscP5.*;
import netP5.*;

OscP5 oscP5;

int port = 10002;

void initServer() {
  oscP5 = new OscP5(this, port);
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message.");
  println(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  
  if(theOscMessage.checkAddrPattern("/play") == true && theOscMessage.checkTypetag("s")) {
      movieProgramme.loadDir(theOscMessage.get(0).stringValue());
  } else if(theOscMessage.checkAddrPattern("/mask") == true && theOscMessage.checkTypetag("s")) {
    String mask = theOscMessage.get(0).stringValue();
    if (mask.equals("none")) {
      currentMaskFileName = null;
    } else {
      currentMaskFileName = mask;
    }
    loadNewMask = true;
  } else if(theOscMessage.checkAddrPattern("/setting") == true) {
      String setting = theOscMessage.get(0).stringValue();
      if (setting.equals("colour")) {
        String colourFilter = theOscMessage.get(1).stringValue();
        if (colourFilter.equals("normal")) {
          currentColourShaderName = null; loadShaders();
        } else {
          currentColourShaderName = colourFilter; loadShaders();
        }
      }
  } 
}
