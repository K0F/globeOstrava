

void setup(){
  size(1280,720,P2D);


}

void init(){
  
  frame.removeNotify();

  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}



void draw(){


  frame.setLocation(0,0);

  background(0);
  stroke(255);


  pushMatrix();
  translate(width/2,height/2);
  rotate(frameCount/1000.0);
  translate(-width/2,-height/2);

  for(int i = 0; i < width;i+=10){
    line(i,0,i,width);
  }

  for(int i = 0; i < width;i+=10){
    line(0,i,width,i);
  }


  popMatrix();
}
