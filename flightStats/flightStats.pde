JSONObject json;

ArrayList tracks;

String filenames[];

boolean render = false;

void setup() {
  size(1920/2,1080/2);

  smooth();

  readAll();

  //tracks = new ArrayList();
  //parseFile("PRG.txt");

}

void draw(){
  readAll();
  background(0);

  noFill();
  stroke(255,15);
  for(Object o:tracks){
    Track tmp = (Track)o;
    tmp.plot();
  }

  if(frameCount==1){
    save("screenshot.png");
  }

  if(render)
    saveFrame("/home/kof/render/airplanes/air#####.png");

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

  java.io.File folder = new java.io.File(dataPath(""));

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
    parseFile(filenames[i]);
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

