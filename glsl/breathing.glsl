// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float time;
uniform float ratio;
uniform vec2 mouse;

#define PI 3.1416
#define PI2 (2.0 * PI)

/*
  Complex square
 */
highp vec2 to_the_2(highp vec2 z){
    highp vec2 old_z;
    // Keep the current (old) value
    old_z = z;
    
    // Set new values according to math
    z.x = pow(z.x,2.0) - pow(z.y,2.0);
    z.y = 2.0 * old_z.x * old_z.y;

    return z;
}

void main(void){
    float x = UV.x * ratio;
    float y = UV.y;
    
    vec4 col = vec4(0.0);
    
    vec2 z = vec2(0.0, 0.0);
    vec2 c = vec2(-y+0.4, x - 0.5);
	c *= 5.0;
    float maxit = 0.0;
    
   	for(int i = 0; i < 25; i++){
        
        float lz = length(z);
       	
        z = 1.0 * to_the_2(z) + 0.1 * z + c;
        
        if(length(z) > 4.0 * cos(time * PI2) - 1.8){
        	maxit = float(i);
        	break;
        }
    }
    
    if(length(z) < 4.0){
   		col.r = 0.8 - maxit/10.0;
    }
    
    col *= 1.0 - 1.0 * pow(length(vec2(x-0.5,y-0.5)), 2.0);
    
    
    col.a = 1.0;
    
    gl_FragColor = col;
}