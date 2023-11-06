#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void) {
  vec2 tc = vertTexCoord.st + vec2(+texOffset.s, +texOffset.t);
  vec4 fragColor = texture2D(texture, tc);
  float brightness = (fragColor.r + fragColor.g + fragColor.b) / 3.0;
  gl_FragColor = vec4(brightness, brightness, brightness, 1.0);  
}
