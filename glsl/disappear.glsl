// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float time;


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
    float x = (UV.x - 0.5)*3.0;
    float y = (UV.y - 0.5)*3.0;

    highp vec2 z = vec2(x,y);
    highp vec2 c = vec2(0.285,mod(time,1000.0)/1000.0);

    float maxit = 0.0;    

	for(int i = 0; i < 20; i++){
         
		z = to_the_2(z) + 0.3 * sin(z * 3.0 * c * 3.1416 + 2.0) + c;

    	if(length(z) > 2.0){
			maxit = float(i);
        	break;
        }
    }


    gl_FragColor =
        vec4(
            sin(1.0*maxit/20.0)*0.7,
            cos(1.0 * maxit/2.0)*0.0,
            cos(maxit/10.0) * -0.1,
            1.0
        );
}