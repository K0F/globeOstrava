PShader custom;
PShape sphere;

boolean RANDOM_DRAW = true;

PGraphics airplanesLayer;
PImage normalTexture;

Airports aData;

Globe globe;

float time = 0.0;

boolean TEXTURE = true;

void INIT_SHADER() {
  custom.set("NR_Ammount", 0.04);

  custom.set("AmbientColour", 0.2, 0.2, 0.2);
  custom.set("DiffuseColour", 0.8, 0.8, 0.8);
  custom.set("SpecularColour", 0.8, 0.8, 0.8);
  custom.set("AmbientIntensity", 0.4);
  custom.set("DiffuseIntensity", 0.9);
  custom.set("SpecularIntensity", 0.7);
  custom.set("Roughness", 0.5);
  custom.set("Sharpness", 0.01);

  custom.set("diffuseTexture", globe.texmap);
  custom.set("normalTexture", normalTexture);
  custom.set("airplanesLayer", airplanesLayer);

  custom.set("time", time);


  // custom.set("inTexcoord", 300,300);
}

////////////////////////////////////////////////////////

void keyPressed() {

  if(key=='t'){
    TEXTURE=!TEXTURE;
    return;
  }

  try {
    println("---------------------------------");
    println("reloading shader");
    //resetShader();
    custom = loadShader("frag.glsl", "vert.glsl");
   // INIT_SHADER();
   // shader(custom);
    println("---------------------------------");
  } 
  catch(Exception e) {
    println(e);
  }
}
////////////////////////////////////////////////////////

void setup(){

  size(1024,768,P3D);

  println("loading shaders ... ");

  custom = loadShader("frag.glsl", "vert.glsl");
  normalTexture = loadImage("normal.png");
  print("OK!");
  println("");

  globe = new Globe("The-globe-at-night.jpg");
  

  println("loading airport data ... ");
  
  aData = new Airports("airports.dat");

  print("OK!");
  println("");

  println("drawing airport data ... ");
  
  airplanesLayer = createGraphics(2048,1024,JAVA2D);
  airplanesLayer.beginDraw();
  //airplanesLayer.background(0);

  
  for(int i = 0 ; i < aData.airports.size();i++){
    Airport tmp = (Airport)aData.airports.get(i);
    tmp.plot(airplanesLayer);
  }
  airplanesLayer.endDraw();

  airplanesLayer.save("data/airplanesLocation.png");

  print("OK!");
  println("");
  //sphere = loadShape("globe.obj");
  //sphere.scale(100);


  noCursor();

  INIT_SHADER();

  ortho();
}

void init(){

  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();

}


////////////////////////////////////////////////////////


void draw(){

  if(RANDOM_DRAW)
if(frameCount%2==0){
  

  airplanesLayer.beginDraw();
  int sel1 = (int)random(aData.airports.size());
  Airport tmp1 = (Airport)aData.airports.get(sel1);
  
  for(int i = 0 ; i < 20;i++){
  int sel2 = (int)random(aData.airports.size());
  Airport tmp2 = (Airport)aData.airports.get(sel2);
  airplanesLayer.stroke(255,15);
  airplanesLayer.line(tmp1.x,tmp1.y,tmp2.x,tmp2.y);
  }
  airplanesLayer.endDraw();


  //custom.set("diffuseTexture", globe.texmap);
  custom.set("normalTexture", normalTexture);  
  custom.set("airplanesLayer", airplanesLayer);
}
//placement hack
  if(frameCount<=1)
    frame.setLocation(0,0);


  background(0);
  pointLight(250, 250, 240, -100, 1000, 750); 
  shader(custom);
  //translate(width/2,height/2,0);
  //shape(sphere);
  globe.draw();
}


////////////////////////////////////////////////////////


class Plane{
  PVector pos;
  ArrayList trace;
  Airport A,B;

  Plane(PVector _pos){
    trace = new ArrayList();
    pos = new PVector(_pos.x,_pos.y,_pos.z);
  }

  void trace(){
    trace.add(new PVector(pos.x,pos.y,pos.z));

    if(trace.size()>100){
      trace.remove(0);
    }
  }
}

////////////////////////////////////////////////////////


class Globe{
  PImage bg;
  PImage texmap;
  PGraphics basemap;

  int sDetail = 140;  // Sphere detail setting
  float rotationX = 0;
  float rotationY = 0;
  float velocityX = 0;
  float velocityY = 0;
  float globeRadius = 900;
  float pushBack = 0;

  float[] cx, cz, sphereX, sphereY, sphereZ;
  float sinLUT[];
  float cosLUT[];
  float SINCOS_PRECISION = 0.5;
  int SINCOS_LENGTH = int(360.0 / SINCOS_PRECISION);

  PVector axis;
  PVector pos;
  float angle;


  Globe(String filename){
    texmap = loadImage(filename);
    //texmap.filter(GRAY);

    basemap = createGraphics(texmap.width,texmap.height,P2D);
    initializeSphere(sDetail);
    pos = new PVector(width/2,height/2,0);
    axis = new PVector(0.1,1,0);
    angle = 0;
  }

  void draw(){
    move();

    basemap.beginDraw();

    if(TEXTURE)
      basemap.image(texmap,0,0);

    if(!TEXTURE){
      basemap.background(0);
      for(float f = 0 ; f < texmap.width ; f+=texmap.width/24.0){
        basemap.strokeWeight(10);
        basemap.stroke(255,120);
        basemap.line(f,0,f,texmap.height);
      }

      for(float f = 0 ; f < texmap.height ; f+=texmap.height/12.0){
        basemap.stroke(255,120);
        basemap.line(0,f,texmap.width,f);
      }
    }

    basemap.endDraw();

    renderGlobe();

    //fill(0,120);
    //stroke(255,90);
    /*
       pushMatrix();
       translate(pos.x,pos.y,pos.z);
       rotate(angle,axis.x,axis.y,axis.z);
       texturedSphere(diameter, map);
       popMatrix();
     */
  }

  void move(){
    velocityY = -0.05;
  }

  void renderAirports(){

    pushMatrix();
    translate(pos.x, pos.y, pushBack);
    
    pushMatrix();
    rotateX( radians(-rotationX) );  
    rotateY( radians(270 - rotationY) );
    popMatrix();
    popMatrix();
  }

  void renderGlobe() {
    pushMatrix();
    translate(pos.x, pos.y, pushBack);
    pushMatrix();
    noFill();
    stroke(255,200);
    strokeWeight(2);
    smooth();
    popMatrix();
    //lights();    
    pushMatrix();
    rotateX( radians(-rotationX) );  
    rotateY( radians(270 - rotationY) );
    fill(200);
    noStroke();
    //textureMode(IMAGE);  
    texturedSphere(globeRadius, basemap);
    popMatrix();  
    popMatrix();
    rotationX += velocityX;
    rotationY += velocityY;
    velocityX *= 0.95;
    velocityY *= 0.95;

    // Implements mouse control (interaction will be inverse when sphere is  upside down)
    if(mousePressed){
      velocityX += (mouseY-pmouseY) * 0.01;
      velocityY -= (mouseX-pmouseX) * 0.01;
    }
  }

  void initializeSphere(int res)
  {
    sinLUT = new float[SINCOS_LENGTH];
    cosLUT = new float[SINCOS_LENGTH];

    for (int i = 0; i < SINCOS_LENGTH; i++) {
      sinLUT[i] = (float) Math.sin(i * DEG_TO_RAD * SINCOS_PRECISION);
      cosLUT[i] = (float) Math.cos(i * DEG_TO_RAD * SINCOS_PRECISION);
    }

    float delta = (float)SINCOS_LENGTH/res;
    float[] cx = new float[res];
    float[] cz = new float[res];

    // Calc unit circle in XZ plane
    for (int i = 0; i < res; i++) {
      cx[i] = -cosLUT[(int) (i*delta) % SINCOS_LENGTH];
      cz[i] = sinLUT[(int) (i*delta) % SINCOS_LENGTH];
    }

    // Computing vertexlist vertexlist starts at south pole
    int vertCount = res * (res-1) + 2;
    int currVert = 0;

    // Re-init arrays to store vertices
    sphereX = new float[vertCount];
    sphereY = new float[vertCount];
    sphereZ = new float[vertCount];
    float angle_step = (SINCOS_LENGTH*0.5f)/res;
    float angle = angle_step;

    // Step along Y axis
    for (int i = 1; i < res; i++) {
      float curradius = sinLUT[(int) angle % SINCOS_LENGTH];
      float currY = -cosLUT[(int) angle % SINCOS_LENGTH];
      for (int j = 0; j < res; j++) {
        sphereX[currVert] = cx[j] * curradius;
        sphereY[currVert] = currY;
        sphereZ[currVert++] = cz[j] * curradius;
      }
      angle += angle_step;
    }
    sDetail = res;
  }


  // Generic routine to draw textured sphere
  void texturedSphere(float r, PImage t) {
    int v1,v11,v2;
    r = (r + 240 ) * 0.33;
    beginShape(TRIANGLE_STRIP);
    texture(t);
    float iu=(float)(t.width-1)/(sDetail);
    float iv=(float)(t.height-1)/(sDetail);
    float u=0,v=iv;
    for (int i = 0; i < sDetail; i++) {
      vertex(0, -r, 0,u,0);
      vertex(sphereX[i]*r, sphereY[i]*r, sphereZ[i]*r, u, v);
      u+=iu;
    }
    vertex(0, -r, 0,u,0);
    vertex(sphereX[0]*r, sphereY[0]*r, sphereZ[0]*r, u, v);
    endShape();   

    // Middle rings
    int voff = 0;
    for(int i = 2; i < sDetail; i++) {
      v1=v11=voff;
      voff += sDetail;
      v2=voff;
      u=0;
      beginShape(TRIANGLE_STRIP);
      texture(t);
      for (int j = 0; j < sDetail; j++) {
        vertex(sphereX[v1]*r, sphereY[v1]*r, sphereZ[v1++]*r, u, v);
        vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2++]*r, u, v+iv);
        u+=iu;
      }

      // Close each ring
      v1=v11;
      v2=voff;
      vertex(sphereX[v1]*r, sphereY[v1]*r, sphereZ[v1]*r, u, v);
      vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2]*r, u, v+iv);
      endShape();
      v+=iv;
    }
    u=0;

    // Add the northern cap
    beginShape(TRIANGLE_STRIP);
    texture(t);
    for (int i = 0; i < sDetail; i++) {
      v2 = voff + i;
      vertex(sphereX[v2]*r, sphereY[v2]*r, sphereZ[v2]*r, u, v);
      vertex(0, r, 0,u,v+iv);    
      u+=iu;
    }
    vertex(sphereX[voff]*r, sphereY[voff]*r, sphereZ[voff]*r, u, v);
    endShape();
  }
}
