String [] lines;
float valsX[],valsY[];
int w,h;

PGraphics mapX,mapY;

void setup(){
  size(1280,720,P2D);

  lines = loadStrings("warpTable.txt");

  h = lines.length;
  w = splitTokens(lines[0],";").length;

  println("dimmensions: "+w+" x "+h);

  valsX = new float[w*h];
  valsY = new float[w*h];

  float lowX = 1000, highX=-19200;
  float lowY = 1000, highY=-19200;

  for(int y = 0 ; y < h;y++){
    String tmp[] = splitTokens(lines[y],";");
    for(int x = 0 ; x < w;x++){
      String sub[] = splitTokens(tmp[x],",");
      float X = parseFloat(sub[0]);
      float Y = parseFloat(sub[1]);
      
      lowX = min(lowX,X);
      lowY = min(lowY,Y);
      
      highX = max(highX,X);
      highY = max(highY,Y);

      valsX[y*w+x] = X;
      valsY[y*w+x] = Y;
    }
  }

  println("lowX: "+lowX+", highX: "+highX);
  println("lowY: "+lowY+", highY: "+highY);

  

  mapX = createGraphics(w,h,JAVA2D);
  mapX.loadPixels();
  
  mapY = createGraphics(w,h,JAVA2D);
  mapY.loadPixels();


  for(int i = 0 ; i < valsX.length;i++){
    mapX.set(i%w,(int)(i/(w+0.0)),getColorFromInt((int)map(valsX[i],lowX,highX,0,65535) ));
    mapY.set(i%w,(int)(i/(w+0.0)),getColorFromInt((int)map(valsY[i],lowY,highY,0,65535) ));
  }

  mapX.save("testX.png");
  mapY.save("testY.png");
}

color getColorFromInt(int i) {
  int B_MASK = 255;
  int G_MASK = 255<<8;
  int R_MASK = 255<<16;

  int r = i & R_MASK;
  int g = i & G_MASK;
  int b = i & B_MASK;

  return (color(r,g,b));
}


void draw(){
  image(mapX,0,0,width,height);
}
