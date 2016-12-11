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
    
    vec2 c = vec2(0.1, 0.7 + (cos(PI2 * time) * 0.1 + 0.1));
    vec2 z = vec2(x - 0.5 * ratio, y - 0.5);
	z *= 3.0;
    float maxit = 0.0;
    
    bool in_set = true;
    
   	for(int i = 0; i < 50; i++){
       	z = to_the_2(z) + to_the_2(to_the_2(to_the_2(to_the_2(to_the_2(to_the_2(z)))))) + c;
        
        if(length(z) > 2.0){
        	maxit = float(i);
            in_set = false;
        	break;
        }
    }
    
    if(!in_set){
    	col.g = maxit/50.0;
    } else {
        col.g = maxit/50.0;
        col.r = length(z);
    }
    
    col.b = maxit/50.0;
    col.a = 1.0;
    
    gl_FragColor = col;
}
