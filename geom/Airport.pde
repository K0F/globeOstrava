float min_lon = 12.406;
float max_lon = 18.844;

float min_lat = 48.5868;
float max_lat = 51.0515;


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

      try {  
        airports.add(
            new Airport(
              parseInt(radek[0]),
              radek[1],
              radek[2],
              radek[3],
              parseFloat(radek[5]), 
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

    x = map(lon, min_lon, max_lon, 0, width);
    y = map(lat, min_lat, max_lat, height, 0);

  }
}
