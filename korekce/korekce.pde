

/*


[560, 540] -> [66.6st el, 0st az] -> [399, 671] -> [0.4581, 0.5608]
[960, 140] -> [66.6st el, 270st az] -> [960, 53] -> [0.5, 0.4598]
[960, 540] -> [0st el, 0st az] -> [960, 411] -> [0.5, 0.44031]
[960, 940] -> [66.6st el, 90st az] -> [960, 847] -> [0.5, 0.4572]
[1360, 540] -> [66.6st el, 180st az] -> [1520, 671] -> [0.5419, 0.5608]
*/


String raw[];

void setup(){
  size(1920,1080);





}



void draw(){
  background(255);


  line(560,540,399,671);
  line(960,140,960,53);
  line(960,540,960,411);
  line(960,940,960,847);
  line(1360,540,1520,671);

  cross(399,671);
  cross(960,53);
  cross(960,411);
  cross(960,847);
  cross(1520,671);

  




}

void keyPressed(){
  save("table.png");
}

void cross(float x,float y){
  
  pushMatrix();
  translate(x,y);

  line(-5,0,5,0);
  line(0,-5,0,5);
  popMatrix();
}
