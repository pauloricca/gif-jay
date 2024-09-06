String settingsFileName = "data/settings.json";

void saveSettings() {
  JSONObject state = new JSONObject();
  
  for (int i = 0; i < controllables.size(); i++) {
      Controllable controllable = controllables.get(i);
      
      JSONObject controllableState = new JSONObject();
      controllableState.setFloat("value", controllable.val());
      controllableState.setFloat("autoMinVal", controllable.autoMinVal);
      controllableState.setFloat("autoMaxVal", controllable.autoMaxVal);
      controllableState.setString("automation", controllable.getAutomation());
      
      state.setJSONObject(controllable.name, controllableState);
  }
  
  state.setString("galleries", String.join(";", galleries));
  state.setString("currentMainShaderName", currentMainShaderName);
  state.setString("currentPostFXShaderName", currentPostFXShaderName);
  state.setString("currentColourShaderName", currentColourShaderName);
  
  saveJSONObject(state, settingsFileName);
}

void loadSettings() {
  JSONObject state = loadJSONObject(settingsFileName);
  
  if (state == null) return;
  
  if (state.getString("galleries") != null) {
    galleries = state.getString("galleries").split(";");
    
    for (int i = 0; i < controllables.size(); i++) {
      Controllable controllable = controllables.get(i);
      
      if (controllable.name == "gallery") {
        if (controllable.slider != null) {
          controllable.slider.setRange(0, galleries.length);
        }
      }
    }
  }
  
  if (state.getString("currentMainShaderName") != null) currentMainShaderName = state.getString("currentMainShaderName"); 
  if (state.getString("currentPostFXShaderName") != null) currentPostFXShaderName = state.getString("currentPostFXShaderName");
  if (state.getString("currentColourShaderName") != null) currentColourShaderName = state.getString("currentColourShaderName");
  
  for (int i = 0; i < controllables.size(); i++) {
      Controllable controllable = controllables.get(i);
      
      JSONObject controllableState = state.getJSONObject(controllable.name);
      
      if (controllableState != null) {
        controllable.val(controllableState.getFloat("value"));
        controllable.autoMinVal = controllableState.getFloat("autoMinVal");
        controllable.autoMaxVal = controllableState.getFloat("autoMaxVal");
        controllable.setAutomation(controllableState.getString("automation"));
      }
  }
}
