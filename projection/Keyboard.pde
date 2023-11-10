void keyPressed() {
  keyboardPressed(key);
}

void keyboardPressed(int key) {
  int programmeNumber = -1;
  
  // Numeric keys
  //if(key == 96) programmeNumber = 0; // `
  if(key >= 49 && key <= 57) programmeNumber = key - 49;
  if(key == 48) programmeNumber = 9; // 0
  if(key == 45) programmeNumber = 10; // -
  if(key == 61) programmeNumber = 11; // =
  
  if (programmeNumber > -1 && programmeNumber < programmes.size()) {
    setProgramme(programmes.get(programmeNumber));
  } else {
    switch (key) {
      case 113: currentMainShaderName = "noise"; loadShaders(); break; // q
      case 119: currentMainShaderName = "variations"; loadShaders(); break; // w
      case 101: currentMainShaderName = "variations-chrome-waves"; loadShaders(); break; // e
      case 114: currentMainShaderName = "variations-chrome"; loadShaders(); break; // r
      
      case 97: currentPostFXShaderName = "bloom"; loadShaders(); break; // a
      case 115: currentPostFXShaderName = "glitch"; loadShaders(); break; // s
      case 100: break; // d
      case 102: break; // f
      
      case 122: currentColourShaderName = null; loadShaders(); break; // z
      case 120: currentColourShaderName = "black-and-white"; loadShaders(); break; // x
      case 99: currentColourShaderName = "acid"; loadShaders(); break; // c
      case 118: currentColourShaderName = "neon"; loadShaders(); break; // v
      case 98: currentColourShaderName = "edges"; loadShaders(); break; // b
    }
  }
}
