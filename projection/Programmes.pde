public interface Programme {
  public void draw(PGraphics pg, float strength);
}

public class ImageProgramme implements Programme {
  private PImage img;
  
  public ImageProgramme(PImage img) {
    this.img = img;
  }
  
  public void draw(PGraphics pg, float strength) {
    pg.colorMode(RGB, 255, 255, 255);
    pg.tint(255, 255 * strength);
    pg.image(img, 0, 0, base.width, base.height);
  }
}

public class HorizonProgramme implements Programme {
  public void draw(PGraphics pg, float strength) {
    float thickness = strength * pg.height;
    pg.noStroke();
    pg.rectMode(CORNERS);
    pg.rect(0, (pg.height - thickness)/2, pg.width, (pg.height + thickness)/2);
  }
}

public class BarsProgramme implements Programme {
  int nBars;
  
  public BarsProgramme(int nBars) {
    this.nBars = nBars;
  }
  
  public void draw(PGraphics pg, float strength) {
    pg.noStroke();
    pg.rectMode(CENTER);
    
    for(int i = 0; i < nBars; i++) {
      float thickness = pow(strength, 1 + abs(i-(nBars/2))) * pg.height / nBars;
      pg.rect(pg.width / 2, (i + 0.5) * pg.height / nBars, pg.width, thickness);
    }
  }
}

public class CubeProgramme implements Programme {
  public void draw(PGraphics pg, float strength) {
    float cubeSize = (1 + strength) * pg.height * 0.25;
    pg.noFill();
    pg.translate(pg.width/2, pg.height/2, 0);
    pg.strokeWeight(strength * 8);
    for(int i = 1; i <= 3; i++)
    {
      pg.rotateY(time * i);
      pg.rotateX(time * i * 0.2);
      pg.box(cubeSize);
    }
  }
}

public class CircleProgramme implements Programme {
  boolean hasFill;
  int nCircles;
  boolean rotating;
  
  public CircleProgramme(boolean hasFill, int nCircles, boolean rotating) {
    this.hasFill = hasFill;
    this.nCircles = nCircles;
    this.rotating = rotating;
  }
  
  public void draw(PGraphics pg, float strength) {
    float radius = strength * pg.width * 0.7;
    
    pg.ellipseMode(CENTER);
    
    if(hasFill) pg.noStroke();
    else pg.noFill();
    
    for(int i = 1; i <= this.nCircles; i++) {
      pg.strokeWeight(strength * (4 + 12 * (i / float(this.nCircles))));
      float radiusMultiplier = 0.1 + pow((i / float(this.nCircles)), 1.5) * 0.9;
      pg.pushMatrix();
      pg.translate(pg.width/2, pg.height/2);
      if (rotating) {
        pg.rotateY(time * i);
        pg.rotateX(time * i * 0.2);
      }
      pg.ellipse(0, 0, radius * radiusMultiplier, radius * radiusMultiplier);
      pg.popMatrix();
    }
  }
}


public class ArcProgramme implements Programme {
  boolean hasFill;
  int nCircles;
  boolean rotating;
  
  public ArcProgramme(boolean hasFill, int nCircles) {
    this.hasFill = hasFill;
    this.nCircles = nCircles;
  }
  
  public void draw(PGraphics pg, float strength) {
    float radius = pg.width * 0.7;
    
    pg.ellipseMode(CENTER);
    
    if(hasFill) pg.noStroke();
    else pg.noFill();
    
    for(int i = 1; i <= this.nCircles; i++) {
      pg.strokeWeight(strength * (1 + 4 * (i / float(this.nCircles))));
      float radiusMultiplier = 0.1 + pow((i / float(this.nCircles)), 1.5) * 0.9;
      pg.pushMatrix();
      pg.translate(pg.width/2, pg.height/2);
      float noiseFactor = noise(i) * 2;
      pg.rotateY((time * 0.1) * noiseFactor * i * 0.2);
      pg.rotateX((time * 0.1) * noiseFactor * i * 0.1);
      float speed = 3;
      pg.arc(0, 0, 
        radius * radiusMultiplier * sin(time * 0.1 * i) * strength, 
        radius * radiusMultiplier * sin(time * 0.1 * i) * strength, 
        2 * noiseFactor * time * speed + noiseFactor * TWO_PI, 
        2 * noiseFactor * time * speed + noiseFactor * TWO_PI + TWO_PI * 0.5 * strength);
      pg.popMatrix();
    }
  }
}
