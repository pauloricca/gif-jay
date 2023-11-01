void animateRoamingControllers() {
  for (int i = 0; i < controllables.size(); i++) {
      Controllable controllable = controllables.get(i);
      
      if (controllable.roamingToggle != null) {
        if(controllable.roamingToggle.getState()) {
          // max and min might be reversed
          float maxVal = max(controllable.autoMaxVal, controllable.autoMinVal);
          float minVal = min(controllable.autoMaxVal, controllable.autoMinVal);
          
          // if we have no space to roam, set value to that value
          if(minVal==maxVal) 
          {
            controllable.isRoaming = true;
            controllable.val(minVal);
          }
          // init roaming
          else if(!controllable.isRoaming)
          {
            // we need to move forward in the noise phase until we find a place that's suitable to start roaming, so that there are no jumps
            
            // if we're over the max, set value to a little less than max
            if(controllable.val() >= maxVal) controllable.val(maxVal - (maxVal - minVal) * 0.95 );
            
            // if we're under the min, set value to a little over min
            if(controllable.val() <= minVal) controllable.val(minVal + (maxVal - minVal) * 0.95 );
            
            // move backwards one step so that we can resume roaming from the point we were in
            controllable.roamingPhase -= roamingSpeed.val();
            
            // search for the next roaming phase that whould make a smooth first movement
            float currentVal = getRoamingValue(controllable.roamingPhase, minVal, maxVal);
            float nextVal;
            do {
              controllable.roamingPhase += roamingSpeed.val();
              nextVal = getRoamingValue(controllable.roamingPhase, minVal, maxVal);
            } while (currentVal < controllable.val() && nextVal > controllable.val() || currentVal > controllable.val() && nextVal < controllable.val());
            
            controllable.val(nextVal);
            
            controllable.isRoaming = true;
          }
          // continue roaming
          else
          {
            controllable.roamingPhase += roamingSpeed.val();
            float nextVal = getRoamingValue(controllable.roamingPhase, minVal, maxVal);
            controllable.val(nextVal);
          }
          
          // roam
        } else if (controllable.isRoaming) controllable.isRoaming = false;
      }
      
      if (controllable.roamingToggle != null && controllable.roamingToggle.getState()) {
      }
  }
}

float getRoamingValue(float phase, float min, float max) {
  noiseDetail(1);
  return min + noise(phase) * 2 * (max - min);
}
