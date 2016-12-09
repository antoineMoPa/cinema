// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float time;
uniform float ratio;
uniform vec2 mouse;

#define PI 3.1415
#define PI2 (2.0*PI)

vec4 point_screen(vec2 pos_in, vec4 col_in){
	vec4 col = vec4(0.0);
	
    float size = 0.03;
    
    vec2 pos = mod(pos_in,vec2(size, size));
    pos /= size;
    float fac = (1.0 - length(pos - vec2(0.5,0.5)));
    
    fac = pow(fac, 5.0);
    
    if(fac < 0.7){
    	fac *= 0.7;
    }
    
    col += col_in * fac;
    
    return col;
}

void main(void){
    float x = UV.x * ratio;
    float y = UV.y;
    
    vec2 pos = vec2(x,y);
    
    vec4 col = vec4(0.0);
    y += 0.05 * cos(x + PI2 * time);
    
    
    col.r += 0.4 * pow(sin(PI2 * time + x * 2.00 + 0.3) + sin(y * 10.0),2.0);
    col.g += sin(PI2 * time + x * 2.4 + 0.2) + sin(y * 10.0 + 0.3);
    col.b += 0.7 * pow(sin(PI2 * time + x * 2.6 + 0.1) + sin(y * 40.0),2.0);
    
    
    col = point_screen(pos, col);
    
    col.a = 1.0;
    
    gl_FragColor = col;
}