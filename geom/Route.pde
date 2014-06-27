class Route{

  int id;
  int srcid,destid;
  Airport A,B;


  Route(int _id,int _srcid, int _destid){
    id = _id;
    srcid = _srcid;
    destid = _destid;
  }

  Route(int _id,Airport _A, Airport _B){
    id = _id;

    A = _A;
    B = _B;
  }

}
