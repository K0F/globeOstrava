


class Plane{
  PVector pos;
  ArrayList trace;
  Airport A,B;
  float speed = 5.0;

  Plane(){
  speed = random(0.01,1.0);
    trace = new ArrayList();
    A = (Airport)aData.airports.get((int)random(aData.airports.size()));
    B = (Airport)aData.airports.get((int)random(aData.airports.size()));
    pos = new PVector(A.x,A.y);
  }

  void draw(PGraphics _tmp){
    move();

    for(int i = 1 ; i< trace.size();i++){
      PVector tmp2 = (PVector)trace.get(i-1);
      PVector tmp1 = (PVector)trace.get(i);
      _tmp.stroke(255,128,12,map(i,0,trace.size(),0,255));
      _tmp.line(tmp1.x,tmp1.y,tmp2.x,tmp2.y);
    }

  }

  void move(){
    PVector dir = new PVector(B.x-A.x,B.y-A.y);
    dir.normalize();
    dir.mult(speed);
    pos.add(dir);
    
    float d = dist(pos.x,pos.y,B.x,B.y);
    if(d<1.0){
    B = (Airport)aData.airports.get((int)random(aData.airports.size()));

    }

    trace();

  }

  void trace(){
    trace.add(new PVector(pos.x,pos.y,pos.z));

    if(trace.size()>100){
      trace.remove(0);
    }
  }
}


