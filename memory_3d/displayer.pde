
public class SecondApplet extends PApplet {
  PImage images[];
  PImage images2[];

  private SyphonServer server = null;
  private String os;
  private Boolean isMac = false;
  private int picWidth = 240;
  private int picHeight = picWidth;
  private float angle = 0f;
  private int elementsX;
  private int elementsY; 
  private float rotations[];
  private int effects[]; 
  
  public SecondApplet(int elementsX, int elementsY) {
    images = new PImage[elementsX * elementsY];
    images2 = new PImage[elementsX * elementsY];
    rotations = new float[elementsX * elementsY];
    effects = new int[elementsX * elementsY];
    this.elementsX = elementsX;
    this.elementsY = elementsY;
  }

  public void settings() {
    size(elementsX * picWidth, elementsY * picHeight, P3D);
  }

  public void setup() {
    frameRate(30);
    os = System.getProperty("os.name");
    println("OS = " + os);
    isMac = os.toLowerCase().indexOf("mac") >= 0;
    if (isMac) {
      server = new SyphonServer(this, "MemorySpiel");
    }
    
    noStroke();
    ortho(-width/2, width/2, -height/2, height/2);
  }

  public void loadImage(int index, PImage image, int effect) {
    
    if(effect == 0) {
      // switch
      images[index] = image;
      images2[index] = image;
      rotations[index] = 0f;
      effects[index] = effect;
      
    } else if(effect == 1) {
      // rotate in
      if(images[index] != image) {
        rotations[index] = 0f;
        images2[index] = image;
        effects[index] = effect;
      }
    }
    
    
  }

  public void draw() {
    background(0);
    int imgCounter = 0;
    

    for (int y = 0; y < elementsY; y++ ) {
      for (int x = 0; x < elementsX; x++ ) {      
          
        pushMatrix();
        //translate(x * picWidth, y * picHeight, 0);
        //image(images[imgCounter],0 , 0, picWidth, picHeight);

        translate((x * picWidth) + (picWidth/2), (y * picHeight) + (picHeight/2), 0);
        rotateY(rotations[imgCounter]);
      
        beginShape(QUADS);
        if (images[imgCounter] != null && images[imgCounter].width > 0) {
          texture(images[imgCounter]);
          vertex(-(picWidth / 2), -(picHeight / 2), 0, 0, 0);
          vertex(picWidth / 2, -(picHeight / 2), 0, images[imgCounter].width, 0);
          vertex(picWidth / 2, picHeight / 2, 0, images[imgCounter].width, images[imgCounter].height);
          vertex(-(picWidth / 2), picHeight / 2, 0, 0, images[imgCounter].height);
        } else {   
          fill(0);
          vertex(-(picWidth / 2), -(picHeight / 2), 0);
          vertex(picWidth / 2, -(picHeight / 2), 0);
          vertex(picWidth / 2, picHeight / 2, 0);
          vertex(-(picWidth / 2), picHeight / 2, 0);
        }
        endShape();
        
        beginShape(QUADS);
        if(images2[imgCounter] != null && images2[imgCounter].width > 0) {  
          texture(images2[imgCounter]);
          vertex(-(picWidth / 2) , -(picHeight / 2) , -1 , images2[imgCounter].width, 0);
          vertex(picWidth / 2    , -(picHeight / 2) , -1 , 0                        , 0);
          vertex(picWidth / 2    , picHeight / 2    , -1 , 0, images2[imgCounter].height);
          vertex(-(picWidth / 2) , picHeight / 2    , -1 , images2[imgCounter].width, images2[imgCounter].height);
        } else {   
          fill(0);
          vertex(-(picWidth / 2), -(picHeight / 2), -1);
          vertex(picWidth / 2, -(picHeight / 2), -1);
          vertex(picWidth / 2, picHeight / 2, -1);
          vertex(-(picWidth / 2), picHeight / 2, -1);
          
        }
        endShape();
        
        popMatrix();
        
        if(effects[imgCounter] == 1) {
          rotations[imgCounter] += PI/20;
          
          if(rotations[imgCounter] >= PI) {
            effects[imgCounter] = 0;
            images[imgCounter] = images2[imgCounter];
            rotations[imgCounter] = 0;
          }
          
        }
        
        
        imgCounter++;
      }
    }
    
    angle += .012;

    if (isMac) {
      try {
        server.sendScreen();
      } 
      catch( Exception ignored) {
      }
    }
  }
}
