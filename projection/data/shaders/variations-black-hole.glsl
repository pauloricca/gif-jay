#ifdef GL_ES
precision highp float;
#endif

#define PI 3.1415926538


uniform sampler2D srcTex;
varying vec4 vertTexCoord;

uniform float time;
uniform float p1; // chromatic aberration
uniform float p2; // scale x, e.g. 0.7
uniform float p3; // flow x, e.g. 0.2
uniform float p4; // distortion
uniform float p5; // octaves
uniform float p6; // scale y, e.g. 0.7
uniform float p7; // flow y, e.g. 0.2
uniform float p8;
uniform vec2 resolution;

//variations
vec2 hyperbolic(vec2 v, float amount);
vec2 sinusoidal(vec2 v, float amount);
vec2 cosinusoidal(vec2 v, float amount);
vec2 pdj(vec2 v, float amount);
vec2 d_pdj(vec2 v, float amount);
float rand(vec2 co);
vec2 julia(vec2 v, float amount);
float cosh(float val);
float tanh(float val);
float sinh(float val);
vec2 sech(vec2 p, float weight);

//operations
vec2 addF(vec2 v1, vec2 v2) { return vec2(v1.x+v2.x, v1.y+v2.y); }
vec2 subF(vec2 v1, vec2 v2) { return vec2(v1.x-v2.x, v1.y-v2.y); }
vec2 mulF(vec2 v1, vec2 v2) { return vec2(v1.x*v2.x, v1.y*v2.y); }
vec2 divF(vec2 v1, vec2 v2) { return vec2(v2.x==0?0:v1.x/v2.x, v2.y==0?0:v1.y/v2.y); }

//Utils
float modF(float a, float b);
mat2 r2d(float a);
vec4 noised(vec3 x);

vec2 getVariation(vec2 p);
vec2 polar(vec2 p);

float distortion = p4 * 5;
float chromaticAberration = p1;

void main( void ) {
    vec2 position = (gl_FragCoord.xy / resolution.xy) - 0.5;
    //position = gl_FragCoord.xy - 0.5;
    vec2 newPosition = position;
    //newPosition = getVariation(position);

    float dist = distance(position.xy, vec2(.0,.0));
    mat2 RotationMatrix = r2d(time * (dist / noised(vec3(position.x, position.y, time)).x / 2000.));
    
    vec2 vari = getVariation(RotationMatrix * position) / 1.5;
    newPosition = position + vari * 0.05 * distortion;
    //newPosition = position + vari * 0.2 * distortion;
    //newPosition = position * 4.1;
    
    gl_FragColor = vec4( 
        texture2D(srcTex, newPosition + 0.5 + p1 * noised(vec3(position.x * 4.0, position.y * 4.0, time * 2)).x * 2 * chromaticAberration).r, 
        texture2D(srcTex, newPosition + 0.5 + p1 * noised(vec3(position.x * 4.0, position.y * 4.0, time * 2)).x * chromaticAberration).g, 
        texture2D(srcTex, newPosition + 0.5 - p1 * noised(vec3(position.x * 4.0, position.y * 4.0, time * 2)).y * 2 * chromaticAberration).b, 
    1 );
}

// 2D rotation matrix
mat2 r2d(float a) {
	float c = cos(a), s = sin(a);
	return mat2(
        c, s, // column 1
        -s, c // column 2
    );
}

vec2 getVariation(vec2 v) {
    float phase = sin(time) * 10.;

    phase = (p2 * 0.1) * (p3 * 30.) + sin(time) * 3.;

    //v = julia(v, distortion+phase/(p3 * 30.));
	//v = sech(v, distortion);

	v = hyperbolic(v, distortion * 0.1);
    //v = hyperbolic(v, phase);
    // v = sinusoidal(v, distortion+phase/(p3 * 30.));
	  //v = cosinusoidal(v, distortion);
    // v = pdj(v, phase * distortion);

    // v = pdj(-v, distortion);

    // v = d_pdj(v, phase * distortion);

    v = subF(julia( mulF(addF(hyperbolic(v,phase*.5),julia(sech(v,phase),distortion*.5)),pdj(v,distortion)),distortion*2.5),d_pdj(v,distortion));

    // v = julia(hyperbolic(v,phase*p3*5),distortion);
    
    // for(int i=0;i<2;i++) v = hyperbolic(v,phase/distortion);
	
    v = addF(pdj(v,phase),mulF(hyperbolic(v,phase),sech(v,distortion*0.01)));

    return v;
}

vec2 polar(vec2 v) {
    float phase = sin(time) * 10.;

    phase = (p2 * 0.1) * (p3 * 20.);

	v = hyperbolic(v, distortion);
    v = sinusoidal(v, distortion+phase/(p3 * 30.));
    v = pdj(v, phase * distortion);
    v = julia(hyperbolic(v,phase*p3*5),distortion);
    
    for(int i=0;i<2;i++) v = hyperbolic(v,phase/distortion);
	
    v = addF(pdj(v,phase),mulF(hyperbolic(v,phase),sech(v,distortion*0.01)));

    return v;
}



vec2 hyperbolic(vec2 v, float amount) {
  float r = length(v) + 1.0e-10;
  float theta = atan(v.x, v.y);
  float x = amount * sin(theta) / r;
  float y = amount * cos(theta) * r;
  return vec2(x, y);
}

vec2 sinusoidal(vec2 v, float amount) {
  return vec2(amount * sin(v.x), amount * sin(v.y));
}

vec2 cosinusoidal(vec2 v, float amount) {
  return vec2(amount * cos(v.y), amount * sin(v.y) * atan(v.y, v.x));
}

vec2 pdj(vec2 v, float amount) {
	vec4 pdj_params = vec4(0.1, 1.9, -0.8, -1.2);
	//vec4 pdj_params = vec4(time, -1.011, 2.08, 10.2);
  	return vec2( amount * (sin(pdj_params[0] * v.y) - cos(pdj_params[1] * v.x)),
    amount * (sin(pdj_params[2] * v.x) - cos(pdj_params[3] * v.y)));
}

vec2 d_pdj(vec2 v, float amount) {
  float h = 0.1; // step
  float sqrth = sqrt(h);
  vec2 v1 = pdj(v, amount);
  vec2 v2 = pdj(vec2(v.x+h, v.y+h), amount);
  return vec2( (v2.x-v1.x)/sqrth, (v2.y-v1.y)/sqrth );
}

float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec2 julia(vec2 v, float amount) {
  float r = amount * sqrt(length(v));
  float theta = 0.5 * atan(v.x, v.y) + (2.0 * rand(vec2(0, 1))) * PI;
  float x = r * cos(theta);
  float y = r * sin(theta);
  return vec2(x, y);
}

float cosh(float val)
{
    float tmp = exp(val);
    float cosH = (tmp + 1.0 / tmp) / 2.0;
    return cosH;
}
 
float tanh(float val)
{
    float tmp = exp(val);
    float tanH = (tmp - 1.0 / tmp) / (tmp + 1.0 / tmp);
    return tanH;
}
 
float sinh(float val)
{
    float tmp = exp(val);
    float sinH = (tmp - 1.0 / tmp) / 2.0;
    return sinH;
}

vec2 sech(vec2 p, float weight) {
  float d = cos(2.0*p.y) + cosh(2.0*p.x);
  if (d != 0)
    d = weight * 2.0 / d;
  return vec2(d * cos(p.y) * cosh(p.x), -d * sin(p.y) * sinh(p.x));
}



vec3 hash(vec3 p){
	p = vec3( dot(p,vec3(127.1,311.7, 74.7)),
			  dot(p,vec3(269.5,183.3,246.1)),
			  dot(p,vec3(113.5,271.9,124.6)));
	return -1.0 + 2.0*fract(sin(p)*43758.5453123);
}

// Gradient noise from iq
// return value noise (in x) and its derivatives (in yzw)
vec4 noised(vec3 x){
    vec3 p = floor(x);
    vec3 w = fract(x);
    vec3 u = w*w*w*(w*(w*6.0-15.0)+10.0);
    vec3 du = 30.0*w*w*(w*(w-2.0)+1.0);
    
    vec3 ga = hash( p+vec3(0.0,0.0,0.0) );
    vec3 gb = hash( p+vec3(1.0,0.0,0.0) );
    vec3 gc = hash( p+vec3(0.0,1.0,0.0) );
    vec3 gd = hash( p+vec3(1.0,1.0,0.0) );
    vec3 ge = hash( p+vec3(0.0,0.0,1.0) );
	vec3 gf = hash( p+vec3(1.0,0.0,1.0) );
    vec3 gg = hash( p+vec3(0.0,1.0,1.0) );
    vec3 gh = hash( p+vec3(1.0,1.0,1.0) );
    
    float va = dot( ga, w-vec3(0.0,0.0,0.0) );
    float vb = dot( gb, w-vec3(1.0,0.0,0.0) );
    float vc = dot( gc, w-vec3(0.0,1.0,0.0) );
    float vd = dot( gd, w-vec3(1.0,1.0,0.0) );
    float ve = dot( ge, w-vec3(0.0,0.0,1.0) );
    float vf = dot( gf, w-vec3(1.0,0.0,1.0) );
    float vg = dot( gg, w-vec3(0.0,1.0,1.0) );
    float vh = dot( gh, w-vec3(1.0,1.0,1.0) );
	
    return vec4( va + u.x*(vb-va) + u.y*(vc-va) + u.z*(ve-va) + u.x*u.y*(va-vb-vc+vd) + u.y*u.z*(va-vc-ve+vg) + u.z*u.x*(va-vb-ve+vf) + (-va+vb+vc-vd+ve-vf-vg+vh)*u.x*u.y*u.z,    // value
                 ga + u.x*(gb-ga) + u.y*(gc-ga) + u.z*(ge-ga) + u.x*u.y*(ga-gb-gc+gd) + u.y*u.z*(ga-gc-ge+gg) + u.z*u.x*(ga-gb-ge+gf) + (-ga+gb+gc-gd+ge-gf-gg+gh)*u.x*u.y*u.z +   // derivatives
                 du * (vec3(vb,vc,ve) - va + u.yzx*vec3(va-vb-vc+vd,va-vc-ve+vg,va-vb-ve+vf) + u.zxy*vec3(va-vb-ve+vf,va-vb-vc+vd,va-vc-ve+vg) + u.yzx*u.zxy*(-va+vb+vc-vd+ve-vf-vg+vh) ));
}


float modF(float a, float b) 
{ 
    return a - ( b * floor(a / b) ); 
} 