#ifdef GL_ES
precision highp float;
#endif


uniform sampler2D srcTex;
varying vec4 vertTexCoord;

uniform float time;
uniform float audio;
uniform float p1; // chromatic aberration, e.g. 0.5
uniform float p2; // scale x, e.g. 0.7
uniform float p3; // flow x, e.g. 0.2
uniform float p4;
uniform float p5;
uniform float p6; // scale y, e.g. 0.7
uniform float p7; // flow y, e.g. 0.2
uniform float p8;
uniform vec2 resolution;

vec3 hash(vec3 p);
vec4 noised(vec3 x);



void main( void ) {
    vec2 position = gl_FragCoord.xy / resolution.xy;

    vec4 noise = noised( vec3(position.x/scale.x, position.y/scale.y, time) );
    for(int i = 1; i < octaves; i++)
    {
        float octaveScale = i * (i+1);
        noise = noise * octaveFalloff + (1-octaveFalloff) * noised( vec3(translationX+position.x/(scale.x/octaveScale), translationY+position.y/(scale.y/octaveScale), time) );
    }
    vec2 stR = vec2( vertTexCoord.s+noise.x*distortion*chromaticAberration.r, vertTexCoord.t+noise.y*distortion*chromaticAberration.r);   
    vec2 stG = vec2( vertTexCoord.s+noise.x*distortion*chromaticAberration.g, vertTexCoord.t+noise.y*distortion*chromaticAberration.g);   
    vec2 stB = vec2( vertTexCoord.s+noise.x*distortion*chromaticAberration.b, vertTexCoord.t+noise.y*distortion*chromaticAberration.b);   

    vec3 srcColor = 1. * vec3( texture2D(srcTex, stR).r, texture2D(srcTex, stG).g, texture2D(srcTex, stB).b );

    gl_FragColor = vec4( srcColor.rgb, 1 );
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