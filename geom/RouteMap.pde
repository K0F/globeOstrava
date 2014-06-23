
class RouteMap{
  String raw;

  String filename;
  Airports airports;
  ArrayList routes;

  RouteMap(String _filename){

    filename = _filename;
    airports = aData;

    routes = new ArrayList();
  }


  void parse(){
    raw = loadStrings(filename);    

    for(int i = 0 ; i < raw.length; i++){
      routes.add()
    }
  }






}
