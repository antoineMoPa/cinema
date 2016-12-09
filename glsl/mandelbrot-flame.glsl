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
    vec2 c = vec2(-y + 0.3, x - 0.5);
	c *= 4.0;
    float maxit = 0.0;
    
    bool in_set = true;
    
   	for(int i = 0; i < 25; i++){
        
        float lz = length(z);
       	z = to_the_2(z) + c + z * length(z* vec2(-2.0 * time + 1.8,time));
        
        if(length(z) > 2.0){
        	maxit = float(i);
            in_set = false;
        	break;
        }
    }
    
    if(!in_set){
    	col.g = maxit/25.0;
    } else {
        col.g = maxit/25.0;
        col.r = length(z);
    }
    col *= 1.0 - pow(time, 2.0);
    col.a = 1.0;
    
    gl_FragColor = col;
}