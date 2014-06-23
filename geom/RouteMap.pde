
class RouteMap{
  String raw[];

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

    if(DEBUG)
      println(routes.size()+" routes sucessfully parsed");

  }


  void parse(){

    for(int i = 0 ; i < raw.length; i++){
      String tmp = raw[i];
      String [] data = splitTokens(tmp,",");

      int a = parseInt(data[3]);
      int b = parseInt(data[5]);

      routes.add(new Route(i,a,b));
    }
  }

}
