PShader fisheye;
PGraphics canvas;
PImage img;

PImage snap;
PImage wrapTextureX,wrapTextureY;

boolean useFishEye = true;

void setup() {
  size(1920,1080,P3D);  
  canvas = createGraphics(width, height, P3D);

  snap = loadImage("snap_crop.jpg");
  wrapTextureX = loadImage("testX.png");
  wrapTextureY = loadImage("testY.png");

  fisheye = loadShader("FishEye.glsl");
  fisheye.set("wrapTextureX", wrapTextureX);  
  fisheye.set("wrapTextureY", wrapTextureY);  
  fisheye.set("rx", (float)width);  
  fisheye.set("ry", (float)height);  
}

void init(){

  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();

  super.init();
}

void draw() {
  fisheye.set("time", millis()/1000.0);  

  if(frameCount<2)
    frame.setLocation(0,0);

  canvas.beginDraw();
  canvas.ortho();
  canvas.background(0);
  canvas.stroke(255);

  for (int i = 0; i < width; i += 20) {
    canvas.line(i, 0, i, height);
  }
  for (int i = 0; i < height; i += 20) {
    canvas.line(0, i, width, i);
  }



  canvas.lights();
  canvas.stroke(255);
  canvas.fill(0);
  canvas.translate(mouseX, mouseY, 0);
  canvas.rotateY(HALF_PI+mouseX/100.0*-1);
  canvas.rotateX(mouseY/100.0*-1);  
  canvas.sphere(200);  
  canvas.endDraw(); 

  if (useFishEye == true) {
    shader(fisheye);
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
  }

}

void mousePressed() {
  if (useFishEye) {
    useFishEye = false;
    resetShader();    
  } else {
    useFishEye = true;
  }
}
