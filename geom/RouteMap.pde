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
      try{
        Route tmp = (Route)routes.get(i);

        Airport a = tmp.A;
        Airport b = tmp.B;

        if(a.ID==src || b.ID==src){
          result.add(tmp);
        }

      }catch(Exception e){
        if(DEBUG)
          println(" error while adding route "+ e +" "+i);
      }
    }
    return result;
  }

  void parse(){

    routes = new ArrayList();

    for(int i = 0 ; i < raw.length; i++){
      String tmp = raw[i];
      String [] data = splitTokens(tmp,",");

      if(data.length==9){

        int a = parseInt(data[3]);
        int b = parseInt(data[5]);

        Airport A = getAirportByID(a);
        Airport B = getAirportByID(b);

        try{
          if(DEBUG)
            println("adding new route "+A.ID + " " + B.ID);

          routes.add(new Route(i,A,B));
        }catch(Exception e){
          ;}
      }else{
        println("got wrong number of parameters"+raw.length);
      }
    }
  }
}
