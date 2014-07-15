#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

const float x = 1.0/255.0;
const float y = 1.0/65025.0;
const float z = 1.0/16581375.0;

uniform vec2 resolution;

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
  vec3 bitShifts = vec3(x,y,z);
  
  return ((dot(colour , bitShifts))/10.0);
}

void main(void) {    
  float X = (unpack(texture2D(wrapTextureX,gl_FragCoord.xy / resolution.xy).rgb)+(vec2(0,0)));
  float Y = (unpack(texture2D(wrapTextureY,gl_FragCoord.xy / resolution.xy).rgb)+(vec2(0,0)));

  vec2 uv = vec2(X,Y) * resolution.xy;

  gl_FragColor = texture2D(textureSampler, uv.xy ) * vertColor;
}
