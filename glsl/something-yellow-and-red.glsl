// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float slowtime;
uniform float ratio;
uniform vec2 smooth_mouse;

#define PI 3.1416
#define PI2 (2.0 * PI)

void main(void){
    float x = UV.x * ratio;
    float y = UV.y;
    
    vec4 col = vec4(0.0);
    
    vec2 z = vec2(x,y);
    
    for(int i = 0; i < 12; i++){
        z -= smooth_mouse;
        z.x += cos(3.0 * z.x) + cos(01.0 * z.y) + 0.01 * cos(PI2 * slowtime);
        z.y += cos(3.0 * z.x) + cos(3.0 * z.y) + 0.03 * cos(PI2 * slowtime);
    }
    
    col.rg = z;

    col /= 20.0;
    col = pow(col, vec4(2.0));
    
    col.a = 1.0;
    
    gl_FragColor = col;
}
