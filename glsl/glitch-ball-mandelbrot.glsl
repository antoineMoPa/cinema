// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float time;
uniform float ratio;
uniform vec2 mouse;

#define PI 3.1416
#define PI2 (2.0 * PI)

vec4 glitch_ball(vec2 pos){
    float x = pos.x;
    float y = pos.y;
    vec4 col = vec4(0.0);
    
    x = x - floor(x * 260.0) + time/100.0;
    y = y - floor(y * 30.0) + time/100.0;
    
    col.r = sin(13.0 * x + y + PI2 * time + 0.3);
    col.g = sin((13.0 + 0.006 * cos(time*PI2 + 30.0 * pos.x)) * x + y + PI2 * time + 0.3);
    col.b = sin((13.0) * x + y + PI2 * time + 0.3);
    
    col = abs(col);
    
    if(distance(pos, vec2(0.5,0.5)) > 0.4){
    	col *= 0.0;
    }
    
    col.a = 1.0;
    return col;
}

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
    
    vec2 c = vec2( -y + 0.5, x - 0.5);
    vec2 z = vec2(0.0, 0.0);
	c *= 4.0;
    c.x -= 0.5;
    float maxit = 0.0;
    
    bool in_set = true;
    
   	for(int i = 0; i < 50; i++){
       	z = to_the_2(z) + c;
        
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
    
    col *= glitch_ball(vec2(x,y));
    
    col.a = 1.0;
    
    gl_FragColor = col;
}