// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float time;
uniform float ratio;
uniform vec2 mouse;

#define PI2 (2.0 * 3.1416)

void main(void){
    float x = UV.x * ratio;
    float y = UV.y;
    
    vec4 col = vec4(0.0);
    
    x = floor(x * 10000.0);
    y = floor(y * 100.0);
    
    col.r = abs(sin(30.0 * x + 3.1416 * time + 0.3));
    col.g = abs(sin(30.0 * x + 3.1416 * time + 0.5));
    col.b = abs(sin(30.0 * x + 3.1416 * time + 1.0));
    col *= cos(30.0 * x * y+ PI2 * time);
    col.a = 1.0;
    
    gl_FragColor = col;
}