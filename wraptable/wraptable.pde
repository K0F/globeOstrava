

String [] lines;
float valsX[],valsY[];
int w,h;

PGraphics map;

void setup(){
  size(1280,720,P2D);

  lines = loadStrings("warpTable.txt");
  
  h = lines.length;
  w = splitTokens(lines[0],";").length;
  
  println("dimmensions: "+w+" x "+h);


  valsX = new float[w*h];
  valsY = new float[w*h];


 for(int y = 0 ; y < h;y++){
    String tmp[] = splitTokens(lines[y],";");
    for(int x = 0 ; x < tmp.length;x++){
    String sub[] = splitTokens(tmp[x],",");
    float X = parseFloat(sub[0]);
    float Y = parseFloat(sub[1]);
    valsX[y*w+x] = X;
    valsY[y*w+x] = Y;
    }
  }

  map = createGraphics(w,h,JAVA2D);
  map.loadPixels();

  for(int i = 0 ; i < valsX.length;i++){
  color c = color(
  map(valsX[i],-1920,1920,0,255),
  map(valsY[i],-1080,1080,0,255),0);
  map.set(i%w,(int)(i/(w+0.0)),c);
  }




  map.save("test.png");
}



void draw(){

  image(map,0,0,width,height);
}
