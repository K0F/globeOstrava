
class RouteMap{
  String raw;

  String filename;
  Airports airports;
  ArrayList routes;

  RouteMap(String _filename){


    if(DEBUG)
      println("loading route data");
    
    filename = _filename;
    airports = aData;

    routes = new ArrayList();
    
    raw = loadStrings(filename);

    if(DEBUG)
      println(raw.length+" routes loaded");

    parse();
  }


  void parse(){

    for(int i = 0 ; i < raw.length; i++){
      routes.add()
    }
  }






}
