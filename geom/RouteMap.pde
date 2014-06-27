////////////////////////////////////////////////////
class RouteMap{
  String raw[];

  String filename;
  ArrayList routes;

  RouteMap(String _filename){

    if(DEBUG)
      println("loading route data");

    filename = _filename;
    //airports = aData;

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
      Airport b = tmp.B;

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

      Airport A = aData.airports.getByID(a);
      Airport B = aData.airports.getByID(b);

      routes.add(new Route(i,A,B));
    }
  }
}
