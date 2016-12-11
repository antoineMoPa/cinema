// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float time;
uniform float ratio;
uniform vec2 smooth_mouse;

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
    z = smooth_mouse - vec2(1.0, -0.5);
    vec2 c = vec2(x - 0.7, y - 0.5);
	c *= 5.0;
    float maxit = 0.0;
    
   	for(int i = 0; i < 20; i++){
        
        float tf = 0.0 * cos(PI2 * time);
        
        float lz = length(z);
       	
        z += to_the_2(vec2(cos(z.x) + tf, sin(z.y))) + c;
        
        if(length(z) > 13.0){
        	maxit = float(i);
        	break;
        }
    }
    
    col.rg = abs(z)/10.0;
    col.b = length(z);
    //col.b = 1.0 - maxit/6.0;
    
    col.a = 1.0;
    
    gl_FragColor = col;
}
