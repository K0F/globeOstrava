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

uniform float time;

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

  float X = unpack(texture2D(wrapTextureX,vertTexcoord.st).rgb)*time;//((clamp(unpack(texture2D(wrapTextureX,vertTexcoord)),0f,65536f)*1569.2)-489.6)/1079.6;
  float Y = unpack(texture2D(wrapTextureY,vertTexcoord.st).rgb)*time;//((clamp(unpack(texture2D(wrapTextureY,vertTexcoord)),0f,65536f)*2721.9)-1630.4)/1091.5;

  vec2 pos2 = vec2(X,Y).xy;

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

  gl_FragColor = texture2D(textureSampler, pos2.xy ) * vertColor;
}
