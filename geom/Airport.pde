boolean DRAW_LINES = false;


float min_lon = -180.0;
float max_lon = 180.0;

float min_lat = 90.0;
float max_lat = -90.0;


class Airports{
  String [] raw;

  ArrayList airports;


  Airports(String _filename){

    parse(_filename);

  }


  void parse(String _filename) {
    raw = loadStrings(_filename);
    println("Pocet letist: "+raw.length);

    airports = new ArrayList();

    
    for (int i = 0 ; i < raw.length ; i++) {
      String radek[] = splitTokens(raw[i], ",\"");

      if(radek.length==11)
      try {  
        airports.add(
            new Airport(
              parseInt(radek[0]),
              radek[1],
              radek[3],
              radek[4],
              parseFloat(radek[7]), 
              parseFloat(radek[6]) 
              ));
      }
      catch(Exception e) {
        ;
      }
    }
  }
}

class Airport{

  String code,country,name;
  int ID;
  float lon,lat,x,y;

  Airport(int _ID,String _name, String _country, String _code, float _lon, float _lat){
    name = _name;
    country = _country;
    code = _code;
    ID = _ID;
    lon = _lon;
    lat = _lat;

    x = map(lon, min_lon, max_lon, 0, airplanesLayer.width);
    y = map(lat, min_lat, max_lat, airplanesLayer.height, 0 );

  }

  void plot(PGraphics _lay){

  _lay.noStroke();
  _lay.fill(255,0,0,155);
  _lay.rectMode(CENTER);
  if(DRAW_LINES)
  for(int i = 0 ; i < 3;i++){
    int sel = (int)random(aData.airports.size());
    Airport tmp = (Airport)aData.airports.get(sel);
    _lay.stroke(255,128,0,5);
    _lay.line(x,y,tmp.x,tmp.y);
  }
  _lay.rect(x,y,2.5,1.25);


  }
}
