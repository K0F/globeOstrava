#extension GL_EXT_gpu_shader4 : enable

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

const float x = 1.0/255.0;
const float y = 1.0/65025.0;
const float z = 1.0/16581375.0;

const vec3 bitShifts = vec3(z,y,x);

uniform sampler2D wrapTextureX;
uniform sampler2D wrapTextureY;

uniform sampler2D textureSampler;
uniform mat4 texcoordMatrix;

varying vec4 vertColor;
varying vec4 vertTexcoord;

const float PI = 3.1415926535;

float unpack (vec3 colour)
{

  const vec3 bitShifts = vec3(
      1.0 / (256.0 * 256.0 * 256.0),
      1.0 / (256.0 * 256.0),
      1.0 / 256.0);
      

  return (dot(colour , bitShifts));
}

void main(void) {    

  vec2 stFactor = vec2(1.0 / abs(texcoordMatrix[0][0]), 1.0 / abs(texcoordMatrix[1][1]));  
  vec2 pos = (2.0 * vertTexcoord.st * stFactor - 1.0);

  float X = clamp(unpack(texture2D(wrapTextureX,pos)),0f,65536f)*1920;
  float Y = clamp(unpack(texture2D(wrapTextureY,pos)),0f,65536f)*1080;

  vec2 pos2 = vec2(X,Y);

  /*
     float l = length(pos);
     if (l > 1.0) {
     gl_FragColor = vec4(0, 0, 0, 1);  
     } else {
     float x = maxFactor * pos.x;
     float y = maxFactor * pos.y;

     float n = length(vec2(x, y));

     float z = sqrt(1.0 - n * n);

     float r = atan(n, z) / PI; 

     float phi = atan(y, x);

     float u = r * cos(phi) + 0.5;
     float v = r * sin(phi) + 0.5;
   */

  gl_FragColor = texture2D(textureSampler, pos2 ) * vertColor;
}
