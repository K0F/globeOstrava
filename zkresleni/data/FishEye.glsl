#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D wrapTexture;
uniform sampler2D textureSampler;
uniform mat4 texcoordMatrix;

varying vec4 vertColor;
varying vec4 vertTexcoord;

const float PI = 3.1415926535;

void main(void) {    
  
  vec2 stFactor = vec2(1.0 / abs(texcoordMatrix[0][0]), 1.0 / abs(texcoordMatrix[1][1]));  
  vec2 pos = (2.0 * vertTexcoord.st * stFactor - 1.0);
  vec4 pos2 = texture2D(wrapTexture,vertTexcoord.st);  
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
    
    gl_FragColor = texture2D(textureSampler, pos2.rg ) * vertColor;
}
