int DONT_INTERSECT = 0;
int COLLINEAR = 1;
int DO_INTERSECT = 2;

float x =0, y=0;


PVector a,b;
PVector i1,i2;

ArrayList agents;

int NUM = 10;

void setup(){
  size(801,401);

  a = new PVector(100,130);
  b = new PVector(width-120,height-77);

  i1 = new PVector(0,0);
  i2 = new PVector(0,0);

  agents = new ArrayList();

  for(int i = 0 ; i < NUM;i++)
    agents.add(new Agent());
}


void draw(){
  int intersected;

  background(0);

  stroke(255,120);

  for(int i = 0 ; i <= height;i+= 20){
    line(0,i,width,i);
  }

  for(int i = 0 ; i <= width;i+= 20){
    line(i,0,i,height);
  }


  a.x = mouseX;
  a.y = mouseY;

  //spodi hrana
  intersected = intersect(a.x, a.y, lerp(a.x,b.x,10), lerp(a.y,b.y,10),0,height,width,height);
  if (intersected == DO_INTERSECT){ i2 = new PVector(x,y); ellipse(x, y, 5, 5);}
  //prava katna
  intersected = intersect(a.x, a.y, lerp(a.x,b.x,10), lerp(a.y,b.y,10),width,0,width,height);
  if (intersected == DO_INTERSECT){ i2 = new PVector(x,y); ellipse(x, y, 5, 5);}
  //leva katna
  intersected = intersect(a.x, a.y, lerp(a.x,b.x,-10), lerp(a.y,b.y,-10),0,0,0,height);
  if (intersected == DO_INTERSECT){ i1 = new PVector(x,y); ellipse(x, y, 5, 5);}
  //horni katna
  intersected = intersect(a.x, a.y, lerp(a.x,b.x,-10), lerp(a.y,b.y,-10),0,0,width,0);
  if (intersected == DO_INTERSECT){ i1 = new PVector(x,y); ellipse(x, y, 5, 5);}

  rect(a.x,a.y,10,10);
  rect(b.x,b.y,10,10);


  for(Object o: agents){

    Agent tmp = (Agent)o;
    tmp.draw();

  }

}


class Agent{

  PVector pos,acc,vel;
  float speed = 4.0;

  Agent(){
    pos = new PVector(a.x,a.y);
    acc = new PVector(0,0);
    vel = new PVector(mouseX-pmouseX,mouseY-pmouseY);
    speed= random(1.0,10.0);
  }

  void draw(){
    move();

    ellipse(pos.x,pos.y,5,5);

  }

  void move(){
    vel.add(acc);
    vel.normalize();
    vel.mult(speed);

    pos.add(vel);


    boolean direct = true;

    float primka = dist(b.x,b.y,pos.x,pos.y);
    float wrap = dist()
    
    if()
    acc = new PVector(b.x-pos.x,b.y-pos.y);


    acc.normalize();

    if(dist(pos.x,pos.y,b.x,b.y)<=speed+1)
      pos = new PVector(a.x,a.y);
    //acc.mult(0.99);

  }

}




int intersect(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4){

  float a1, a2, b1, b2, c1, c2;
  float r1, r2 , r3, r4;
  float denom, offset, num;

  // Compute a1, b1, c1, where line joining points 1 and 2
  // is "a1 x + b1 y + c1 = 0".
  a1 = y2 - y1;
  b1 = x1 - x2;
  c1 = (x2 * y1) - (x1 * y2);

  // Compute r3 and r4.
  r3 = ((a1 * x3) + (b1 * y3) + c1);
  r4 = ((a1 * x4) + (b1 * y4) + c1);

  // Check signs of r3 and r4. If both point 3 and point 4 lie on
  // same side of line 1, the line segments do not intersect.
  if ((r3 != 0) && (r4 != 0) && same_sign(r3, r4)){
    return DONT_INTERSECT;
  }

  // Compute a2, b2, c2
  a2 = y4 - y3;
  b2 = x3 - x4;
  c2 = (x4 * y3) - (x3 * y4);

  // Compute r1 and r2
  r1 = (a2 * x1) + (b2 * y1) + c2;
  r2 = (a2 * x2) + (b2 * y2) + c2;

  // Check signs of r1 and r2. If both point 1 and point 2 lie
  // on same side of second line segment, the line segments do
  // not intersect.
  if ((r1 != 0) && (r2 != 0) && (same_sign(r1, r2))){
    return DONT_INTERSECT;
  }

  //Line segments intersect: compute intersection point.
  denom = (a1 * b2) - (a2 * b1);

  if (denom == 0) {
    return COLLINEAR;
  }

  if (denom < 0){ 
    offset = -denom / 2; 
  } 
  else {
    offset = denom / 2 ;
  }

  // The denom/2 is to get rounding instead of truncating. It
  // is added or subtracted to the numerator, depending upon the
  // sign of the numerator.
  num = (b1 * c2) - (b2 * c1);
  if (num < 0){
    x = (num - offset) / denom;
  } 
  else {
    x = (num + offset) / denom;
  }

  num = (a2 * c1) - (a1 * c2);
  if (num < 0){
    y = ( num - offset) / denom;
  } 
  else {
    y = (num + offset) / denom;
  }

  // lines_intersect
  return DO_INTERSECT;
}


boolean same_sign(float a, float b){
  return (( a * b) >= 0);
}
