#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform sampler2D mapx;
uniform sampler2D mapy;
uniform int width;
uniform int height;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
  //get color-encoded x-position of the source pixel
  vec4 mapXColor = texture2D(mapx, vertTexCoord.st).rgba;
  
  //decode x-position -> will be in a range 0-1
  float vx=((mapXColor.r*256.0)*256.0+mapXColor.g*256.0+mapXColor.b)/float(width);
  
  //get color-encoded y-position of the source pixel
  vec4 mapYColor = texture2D(mapy, vertTexCoord.st).rgba;
  
  //decode y-position -> will be in a range 0-1
  float vy=((mapYColor.r*256.0)*256.0+mapYColor.g*256.0+mapYColor.b)/float(height);
  
  //limit coordinates
  if(vx<0){
      vx=0.0;
  }
  if(vx>1){
      vx=1;
  }
  if(vy<0){
      vy=0.0;
  }
  if(vy>1){
      vy=1.0;
  }
   
  //set current pixel's color the same as the source pixel (with interpolation)
  gl_FragColor=texture2D(texture, vec2(vx,vy)).rgba;
}

