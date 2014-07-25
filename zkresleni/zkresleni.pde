PShader fisheye;
PGraphics canvas;
PImage img;

PImage snap;
PImage wrapTextureX,wrapTextureY;

PImage reference;

boolean useFishEye = true;

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

  fisheye = loadShader("warp4.glsl");
  fisheye.set("wrapTextureX", wrapTextureX);  
  fisheye.set("wrapTextureY", wrapTextureY);  
  fisheye.set("width", (float)width);  
  fisheye.set("height", (float)height);  

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
/*
canvas.image(reference,0,0);
  canvas.camera();
  canvas.stroke(0,90);
  for (int i = 0; i < width; i += 20) {
    canvas.line(i, 0, i, height);
  }
for (int i = 0; i < height; i += 20) {
    canvas.line(0, i, width, i);
  }
    canvas.line(0, 0, width, 0);
 */
 canvas.background(0);
 canvas.ortho();
  float fov = (((mouseX*10.0)+1.0)/(width+0.0));
  float cameraZ = (height/2.0) / tan(fov/2.0);
  
  canvas.camera(0,0,0,0,0,1000,0,1,0);
  canvas.perspective(fov, float(width)/float(height),cameraZ/10.0, cameraZ*10.0);
  
//  canvas.fill(255);
//  canvas.rect(0,0,width,frameCount/10.0);


  canvas.lights();
  canvas.stroke(255);
  canvas.noFill();//fill(0);
  //canvas.translate(width/2, 540, 0);
  canvas.rotateX(HALF_PI);
  canvas.rotateY(frameCount/200.0);  

  canvas.sphere(1080/2);  
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
  }else{
  //reloadShaders();
    save("projectionDeform.png");

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
