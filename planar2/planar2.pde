JSONObject json;

ArrayList tracks;
ArrayList planes;

int NUM_PLANES = 10000;

String filenames[];

PImage shadow, diffuse;

boolean render = true;

void setup() {
  size(1920,1080);

  smooth();

  readAll();

  planes = new ArrayList();


  shadow = loadImage("shade.png");
  diffuse = loadImage("The-globe-at-night.jpg");
  diffuse.filter(GRAY);

  for(int i = 0 ; i < NUM_PLANES;i++){
    planes.add(new Plane());
  }

  background(0);

}

void draw(){

  image(diffuse,0,0,width,height);

  //  fill(0,15);
  //  rect(0,0,width,height);

  noFill();
  strokeWeight(1);
  stroke(255,5);

  /*
     for(Object o:tracks){
     Track tmp = (Track)o;
     tmp.plot();
     }*/

  image(shadow,width-(frameCount%width),0,width,height);
  image(shadow,width-(frameCount%width+width),0,width,height);


  for(int i = 0 ; i < planes.size();i++){
    try{
      Plane tmp = (Plane)planes.get(i);
      tmp.plot();
    }catch(Exception e){
      println("weird error");}
  }



  if(frameCount==1){
    save("screenshot.png");
  }

  if(render)
    saveFrame("/home/kof/render/airplanes/air#####.png");

}


class Plane{
  Track route;
  float speed;
  PVector pos,vel;
  int current;
  PVector target;
  ArrayList trail; 

  Plane(){
    route = (Track)tracks.get((int)random(tracks.size()));
    pos = (PVector)route.waypoints.get(0);
    target = new PVector(pos.x,pos.y);
    vel = new PVector(0,0);
    trail = new ArrayList();

    try{
      target = (PVector)route.waypoints.get(1);
    }catch(Exception e){ 
      planes.remove(this);
      ;}
  }

  void move(){

    pos.add(vel);
    vel = new PVector(target.x-pos.x,target.y-pos.y);
    vel.normalize();
    vel.mult(0.1);
    vel.x *= 1/cos(pos.y/(height+0.0));
    
    if(frameCount%5==0);
    trail.add(new PVector(pos.x,pos.y));

    if(dist(pos.x,pos.y,target.x,target.y)<1){
      current++;
      if(current<route.waypoints.size()){
        target = (PVector)route.waypoints.get(current);
      }else{
        planes.add(new Plane());
        //planes.remove(this);

      }

    }
  }

  void plot(){
    move();
    point(pos.x,pos.y);
    for(int i = 1 ; i < trail.size();i++){

      PVector a = (PVector)trail.get(i-1);
      PVector b = (PVector)trail.get(i);
      line(a.x,a.y,b.x,b.y);

    }
  }


}

class Track{
  ArrayList waypoints;

  Track(ArrayList _wp){
    waypoints = _wp;
  }

  void plot(){
    for(int i = 1;i<waypoints.size();i++){
      //stroke(lerpColor(#ff0000,#00ff00,i/(waypoints.size()+0.0)),50);
      PVector tmp1 = (PVector)waypoints.get(i-1);
      PVector tmp2 = (PVector)waypoints.get(i);
      float d = dist(tmp1.x,tmp1.y,tmp2.x,tmp2.y);
      if(d<width/20){
        line(tmp1.x,tmp1.y,tmp2.x,tmp2.y);
      }
    }
  }
}

void readAll(){
  tracks = new ArrayList();

  java.io.File folder = new java.io.File(dataPath("airports"));

  java.io.FilenameFilter txtFilter = new java.io.FilenameFilter() {
    public boolean accept(File dir, String name) {
      return name.toLowerCase().endsWith(".txt");
    }
  };

  filenames = folder.list(txtFilter);

  println(filenames.length + " airports found");

  // display the filenames
  for (int i = 0; i < filenames.length; i++) {
    //println("parsing "+filenames[i]);
    parseFile("airports/"+filenames[i]);
  }
}

void parseFile(String _filename){

  try{
    json = loadJSONObject(_filename);
    JSONArray tmp = json.getJSONArray("flightTracks");

    for (int i = 0; i < tmp.size(); i++) {

      JSONObject track = tmp.getJSONObject(i); 

      try{
        JSONArray waypoints = track.getJSONArray("waypoints");

        if(waypoints!=null){

          ArrayList wp = new ArrayList();

          for (int ii = 0; ii < waypoints.size(); ii++) {

            JSONObject pos = waypoints.getJSONObject(ii);

            float lat = map(pos.getFloat("lat"),-90,90,height,0);
            float lon = map(pos.getFloat("lon"),-180,180,0,width);
            wp.add(new PVector(lon,lat));
            //   println(lat);
            //   println(lon);
          }

          if(wp.size()>0)
            tracks.add(new Track(wp));
        }
      }catch(Exception e){;}

      try{


        JSONArray positions = track.getJSONArray("positions");

        if(positions!=null){

          ArrayList wp = new ArrayList();

          for (int ii = 0; ii < positions.size(); ii++) {

            JSONObject pos = positions.getJSONObject(ii);

            float lat = map(pos.getFloat("lat"),-90,90,height,0);
            float lon = map(pos.getFloat("lon"),-180,180,0,width);
            wp.add(new PVector(lon,lat));
            //   println(lat);
            //   println(lon);
          }    //print(wp.size()+", ");

          if(wp.size()>0)
            tracks.add(new Track(wp));

        }
      }catch(Exception e){;}
      // println(waypoints);
    }
  }catch(Exception e){println("error parsing"+_filename);}
}

