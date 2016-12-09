// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float time;
uniform float ratio;
uniform vec2 mouse;



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
    float x = -(UV.y - 0.3)*3.0;
    float y = (UV.x - 0.5)*3.0;
	
    vec4 col = vec4(54.0, 70.0, 93.0, 0.0)/255.0;
   	col.a = 1.0;
	
    float sintime = sin(2.0 * 3.1416 * time);	
    
	highp vec2 z = vec2(0.0, 0.0);
	highp vec2 c = vec2(x, y);

    float maxit = 0.0;    
  
	for(int i = 0; i < 20; i++){
		z = to_the_2(z) + c;

    	if(length(z) > 20.0){
			maxit = float(i);
        	break;
        }
    }
    
    if(length(z) < sintime + 0.6){
        col.r = z.x;
        col.b = z.y;
    }
    
    gl_FragColor = col;
}