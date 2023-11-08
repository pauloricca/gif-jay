uniform sampler2D texture;
uniform vec2 resolution;
uniform float strength;
uniform float time;

void main( void )
{
    float Pi = 6.28318530718; // Pi*2
    
    // GAUSSIAN BLUR SETTINGS {{{
    float Directions = 16.0; // BLUR DIRECTIONS (Default 16.0 - More is better but slower)
    float Quality = 5.0; // BLUR QUALITY (Default 4.0 - More is better but slower)
    float Size = strength * 20; // BLUR SIZE (Radius)
    float Power = (1.1 - strength * strength) * 3;
    // GAUSSIAN BLUR SETTINGS }}}

    vec2 Radius = Size/resolution.xy;
    
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = gl_FragCoord.xy / resolution.xy;
    // Pixel colour
    vec4 Color = texture2D(texture, uv);
    
    // Blur calculations
    for( float d=0.0; d<Pi; d+=Pi/Directions)
    {
        for(float i=1.0/Quality; i<=1.0; i+=1.0/Quality)
        {
            vec4 Pixel = texture2D( texture, uv+vec2(cos(d),sin(d))*Radius*i);
            Color += vec4(pow(Pixel.r, Power), pow(Pixel.g, Power), pow(Pixel.b, Power), 1);		
        }
    }
    
    // Output to screen
    Color /= Quality * Directions - 15.0;
    gl_FragColor = texture2D(texture, uv) + Color * 2;
}