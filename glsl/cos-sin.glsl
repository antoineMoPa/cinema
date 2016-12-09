// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float time;
uniform float ratio;
uniform vec2 mouse;

void main(void){
    float x = UV.x * ratio;
    float y = UV.y;
    
    vec4 col = vec4(0.0);
    
    x *= distance(mouse, vec2(x, y));
    y *= distance(mouse, vec2(x, y));
    
    float maxit = 0.0;
    
    float sintime = sin(3.1416 * 2.0 * time);
    
    vec2 val = vec2(x, y);
    
    for(int i = 0; i < 10; i++){
    	maxit = float(i);
        
        float l =  length(val);
        
        val.x *= l * cos(10.0 * x - 3.1416 * time) + 0.01 * sintime;
        val.y *= l * sin(10.0 * y);
        
        if(length(val) > 18.0){
        	break;
        }
    }
    
    col.rg = vec2(maxit / 10.0);
    col.b = maxit/8.0;
    col.a = 1.0;
    
    gl_FragColor = col;
}