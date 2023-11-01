void keyPressed() {
  keyboardPressed(key);
}

void keyboardPressed(int key) {
  int programmeNumber = -1;
  
  // Numeric keys
  if(key == 96) programmeNumber = 0; // `
  if(key >= 49 && key <= 57) programmeNumber = key - 48;
  if(key == 48) programmeNumber = 10; // 0
  if(key == 45) programmeNumber = 11; // -
  if(key == 61) programmeNumber = 12; // =
  
  if (programmeNumber > -1 && programmeNumber < programmes.size()) {
    setProgramme(programmes.get(programmeNumber));
  } else {
    switch (key) {
      case 113: currentShader = "noise"; loadShaders(); break; // q
      case 119: currentShader = "variations"; loadShaders(); break; // w
      case 101:  break; // e
      case 114:  break; // r
      
      case 97: currentPostFXShader = "bloom"; break; // a
      case 115: currentPostFXShader = "glitch"; break; // s
      case 100:  break; // d
      case 102:  break; // f
    }
  }
}