
PGraphics canvas;
PImage img;

PImage snap;
PImage wrapTextureX,wrapTextureY;

PShader warpShader;

PImage reference;

boolean usewarpShader = true;

void setup() {
  size(1920,1080,P3D);  
  canvas = createGraphics(width, height, P3D);
  reloadShaders();
}

void reloadShaders(){

  snap = loadImage("snap_crop.jpg");
  wrapTextureX = loadImage("textureX.png");
  wrapTextureY = loadImage("textureY.png");

  reference = loadImage("table.png");

<<<<<<< HEAD
  warpShader = loadShader("warp4.glsl");

  warpShader.set("width", width);
  warpShader.set("height", height);      
  warpShader.set("mapx", wrapTextureX);  
  warpShader.set("mapy", wrapTextureY);  
=======
  fisheye = loadShader("warp4.glsl");
  fisheye.set("wrapTextureX", wrapTextureX);  
  fisheye.set("wrapTextureY", wrapTextureY);  
  fisheye.set("width", (float)width);  
  fisheye.set("height", (float)height);  
>>>>>>> shader_implement

}

void init(){

  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();

  super.init();
}

void draw() {
  warpShader.set("time", millis()/1000.0);  

  if(frameCount<2)
    frame.setLocation(0,0);

  canvas.beginDraw();

  //canvas.image(reference,0,0);
  // canvas.camera();

  canvas.background(255);
  canvas.stroke(0,90);
  for (int i = 0; i < width; i += 20) {
    canvas.line(i, 0, i, height);
  }
  for (int i = 0; i < height; i += 20) {
    canvas.line(0, i, width, i);
  }
  //  canvas.line(0, 0, width, 0);

  //canvas.ortho();
  //float fov = (((mouseX*10.0)+1.0)/(width+0.0));
  //float cameraZ = (height/2.0) / tan(fov/2.0);

  //canvas.camera(0,0,0,0,0,1000,0,1,0);
  //canvas.perspective(fov, float(width)/float(height),cameraZ/10.0, cameraZ*10.0);

  //  canvas.fill(255);
  //  canvas.rect(0,0,width,frameCount/10.0);


  canvas.lights();
  canvas.stroke(255);
  canvas.noFill();//fill(0);
  //canvas.translate(width/2, 540, 0);
  // canvas.rotateX(HALF_PI);
  //canvas.rotateY(frameCount/200.0);  

  //canvas.sphere(1080/2);  
  canvas.endDraw(); 

  if (usewarpShader == true) {
    shader(warpShader);
  } 

  image(canvas, 0, 0, width, height);
  /* 
     resetShader();
     tint(255,100);
     image(snap,0,0);
     noTint();
   */
}

float sx,sy;

void keyPressed(){
  if(keyCode==UP){
    sy--;
  }else if(keyCode==DOWN){
    sy++;
  }else if(keyCode==LEFT){
    sx--;
  }else if(keyCode==RIGHT){
    sx++;
  }else{
    //reloadShaders();
    save("projectionDeform.png");

  }

}

void mousePressed() {
  if (usewarpShader) {
    usewarpShader = false;
    resetShader();    
  } else {
    usewarpShader = true;
  }
}


PImage createTextureFromLookup(PVector[][] lookup, int coordinateID) {
  PImage tex=createImage(sketchWidth(), sketchHeight(), ARGB);
  tex.loadPixels();
  for (int x = 0; x <tex.width; x++) {
    for (int y = 0; y <tex.height; y++) {
      double val;
      if(coordinateID==1){
        val=lookup[x][y].x;
      }else{
        val=lookup[x][y].y;
      }
      tex.pixels[x+y*tex.width]=convertCoordinateToColor(val);
    }
  }
  tex.updatePixels();
  return tex;
}

int convertCoordinateToColor(double val) {
  if(val<0){
    val=0;
  }
  int ival=(int)val;
  int cr=(int)(ival/256);
  int cg=(int)(ival-cr*256);
  int cb=(int)((val-ival)*256);

  return (int)((0xff<<24)|(cr<<16)|(cg<<8)|(cb));
}

double convertColorToCoordinate(int _color) {
  int p3=(_color & 0x000000FF);
  int p2=(_color & 0x0000FF00)>>8;
  int p1=(_color & 0x00FF0000)>>16;
  return (p1<<8)+p2+(p3/256.0);
}

void loadMapsFromImages(String mapXFile, String mapYFile){
  wrapTextureX = loadImage(mapXFile);
  wrapTextureY = loadImage(mapYFile);
}

double mapDouble(double val, double min1, double max1, double min2, double max2){
  double out=(val-min1)/(max1-min1)*(max2-min2)+min2;
  if(out<min2){
    out=min2;
  }
  if(out>max2){
    out=max2;
  }
  return out;
}

PVector getVectorFromTextures(int idx, PImage ximg, PImage yimg) {
  int[] px=ximg.pixels;
  int[] py=yimg.pixels;
  double newX=convertColorToCoordinate(px[idx]);
  if(newX<0){
    newX=0;
  }
  double newY=convertColorToCoordinate(py[idx]);
  return new PVector((float)newX, (float)newY);
}

