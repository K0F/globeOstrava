
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


  ArrayList getDestinations(int src){
    ArrayList result = new ArrayList();
    for(int i = 0 ; i < routes.size();i++){
      Route tmp = (Route)routes.get(i);

      Airport a = tmp.A;
      Airport b = tmp.A;

      if(a.ID==src||b.ID==src){

        result.add(tmp);
      }
    }
    return result;
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
