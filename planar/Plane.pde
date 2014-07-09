////////////////////////////////////////////////////
class Plane{
  PVector pos;
  ArrayList trace;
  Airport A,B;
  Route route;
  float speed = 5.0;

  Plane(){
    speed = random(0.01,1.0);
    trace = new ArrayList();
    try{
      Route tmp = (Route)routemap.routes.get((int)random(aData.airports.size()));

      A = (Airport)tmp.A;
      B = (Airport)tmp.B;

      pos = new PVector(A.x,A.y);
    
    }catch(Exception e){
      println("error while creating plane "+e);
    }
  }

  void draw(PGraphics _tmp){
    move();
    for(int i = 1 ; i< trace.size();i++){
      PVector tmp2 = (PVector)trace.get(i-1);
      PVector tmp1 = (PVector)trace.get(i);
      //_tmp.stroke(255,128,12,map(i,0,trace.size(),0,255));
      _tmp.stroke(255,map(i,0,trace.size(),0,255));
      _tmp.line(tmp1.x,tmp1.y,tmp2.x,tmp2.y);
    }
  }

  void move(){
    try{
      PVector dir = new PVector(B.x-pos.x,B.y-pos.y);
      dir.normalize();
      dir.mult(speed);
      pos.add(dir);

      float d = dist(pos.x,pos.y,B.x,B.y);

      if(d<=speed){
        A = B;
        B = (Airport)B.pickRandomDestination();
      }

      trace();
    }catch(Exception e){

    }
  }

  void trace(){
    trace.add(new PVector(pos.x,pos.y,pos.z));

    if(trace.size()>50){

      trace.remove(0);
    }
  }
}
////////////////////////////////////////////////////

