uniform sampler2D texture;
uniform vec2 resolution;
uniform float strength;
uniform float time;

void main()
{
	// vec2 uv = ((gl_FragCoord.xy / resolution.xy) * 1.2) - 0.2;
	vec2 uv = gl_FragCoord.xy / resolution.xy;

  vec2 uv2 = uv;
    
	// gl_FragColor = texture(texture, vec2(uv2.x * 0.7, uv2.y * 0.1));
  gl_FragColor = texture2D(texture, vec2(uv.x * 1.4, uv.y * 1.4));
}
