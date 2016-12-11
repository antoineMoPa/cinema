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
    vec2 pos = vec2(x,y);
    vec4 col = vec4(0.0);
    
    x = x - floor(x * 260.0) + time/100.0;
    y = y - floor(y * 30.0) + time/100.0;
    
    col.r = 0.3 * sin(13.0 * x + y + PI2 * time + 0.3);
    col.g = 0.3 * sin((13.0 + 0.006 * cos(time*PI2 + 30.0 * pos.x)) * x + y + PI2 * time + 0.3);
    col.b = 0.3 * sin((13.0) * x + y + PI2 * time + 0.3);
    
    if(distance(pos, vec2(0.5 * ratio, 0.5)) > 0.4){
    	col *= 0.0;
    }
    
    col.a = 1.0;
    
    gl_FragColor = col;
}
