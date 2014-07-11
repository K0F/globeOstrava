/**
 * Fish Eye
 * 
 * This fish-eye shader is useful for dome projection.
 */

PShader fisheye;
PGraphics canvas;
PImage img;

PImage snap;

boolean useFishEye = true;

void setup() {
  size(1245,789,P3D);  
  canvas = createGraphics(width, height, P3D);

  snap = loadImage("snap_crop.jpg");

  fisheye = loadShader("FishEye.glsl");
  fisheye.set("aperture", 180.0);  
}

void draw() {
 
  canvas.beginDraw();
  canvas.ortho();
  canvas.background(0);
/*
canvas.stroke(255);

  for (int i = 0; i < width; i += 5) {
    canvas.line(i, 0, i, height);
  }
  for (int i = 0; i < height; i += 5) {
    canvas.line(0, i, width, i);
  }
  */
  
  
  canvas.lights();
  canvas.stroke(255);
  canvas.noFill();
  canvas.translate(mouseX, mouseY, 100);
  canvas.rotateX(frameCount * 0.01);
  canvas.rotateY(frameCount * 0.01);  
  canvas.sphere(400);  
  canvas.endDraw(); 
  
   if (useFishEye == true) {
    shader(fisheye);
  } 
  image(canvas, 0, 0, width, height);
  
  resetShader();
  tint(255,100);
  image(snap,0,0);
  noTint();
}

void mousePressed() {
  if (useFishEye) {
    useFishEye = false;
    resetShader();    
  } else {
    useFishEye = true;
  }
}
