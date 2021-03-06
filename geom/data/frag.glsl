#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D diffuseTexture;
uniform sampler2D normalTexture;
uniform sampler2D airplanesLayer;

uniform float NR_Ammount;
uniform vec3 AmbientColour;
uniform vec3 DiffuseColour;
uniform vec3 SpecularColour;
uniform float AmbientIntensity;
uniform float DiffuseIntensity;
uniform float SpecularIntensity;
uniform float Roughness;
uniform float Sharpness;

varying vec3 N;
varying vec3 P;
varying vec3 V;
varying vec3 L;
varying vec3 light_pos;

varying vec2  TexCoord;

uniform float time;


void main()
{ 
  float w = 0.38*(1.0-Sharpness);

  vec3 l = normalize(L);
  vec3 n = normalize(N);
  vec3 v = normalize(V);
  vec3 h = normalize(l+v);

  vec3 diff = texture2D(diffuseTexture,TexCoord).rgb;
  vec3 airportsL = texture2D(airplanesLayer,TexCoord).rgb;
  float alL =  texture2D(airplanesLayer,TexCoord).a;
  vec3 normal = normalize(texture2D(normalTexture,TexCoord).rgb * 2.0 - 1.0) * NR_Ammount;

  float NR = max(dot(normal, light_pos),0.0);

  float diffuse = dot(l,n);
  float specular = smoothstep(0.32-w,0.32+w,pow(max(0.0,dot(n,h)),1.0/Roughness));
 
 /*
  gl_FragColor = vec4(
  diff*DiffuseIntensity +
  AmbientColour*AmbientIntensity +
  SpecularColour*specular*SpecularIntensity*normal*NR
  ,1);
  */
  gl_FragColor = vec4(
  alL*airportsL+((1-normal)*NR*0.18)*diff+SpecularColour*SpecularIntensity*specular*(1-normal*NR),1.0
  );


}
