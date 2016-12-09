// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float time;
uniform float ratio;
uniform vec2 mouse;
uniform vec2 smoothmouse;

void main(void){
    float x = UV.x * ratio;
    float y = UV.y;
    
    vec4 col = vec4(0.0);
    
    vec2 pos = vec2(x, y - 1.0);
    
    float sintime = sin(3.1416 * 2.0 * time);
    
	float d = distance(pos, mouse);
    float d2 = pow(d, 2.0);
    
    float fac = 1.0;
    
    x = x + fac * (x - mouse.x) * d2;
    y = y + fac * (y - mouse.y) * d2;
    
    if( abs(cos(100.0 * x)) > 0.9 || 
    	abs(cos(100.0 * y)) > 0.9 ){
    	col.r = 0.5;
    }
    
    col.a = 1.0;
    
    gl_FragColor = col;
}