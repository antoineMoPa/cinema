// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float time;
uniform float ratio;
uniform vec2 mouse;

#define PI 3.1416
#define PI2 (2.0 * PI)

void main(void){
    float x = UV.x * ratio;
    float y = UV.y;
    
    vec4 col = vec4(0.0);
    
    vec2 z = vec2(x,y);
    
    for(int i = 0; i < 12; i++){
        z.x += cos(3.0 * z.x) + cos(01.0 * z.y) + 0.01 * cos(PI2 * time);
        z.y += cos(3.0 * z.x) + cos(3.0 * z.y) + 0.01 * cos(PI2 * time);
    }
    
    col.rg = z;
    
    col.a = 1.0;
    
    gl_FragColor = col;
}