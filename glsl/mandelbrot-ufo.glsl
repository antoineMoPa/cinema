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
    
    col.r = sin(121.0 * x + y + PI2 * time + 0.3);
    col.b = sin((13.) * x + y + PI2 * time + 0.3);
    
    col = abs(col);
    
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

vec4 mandelbrot_glitch(float x, float y){
    vec4 col = vec4(0.0);
    vec2 c = vec2( -y + 0.5, x - 0.5 * ratio);
    vec2 z = vec2(0.0, 0.0);
	c *= 10.0;
    c.x -= 0.5;
    float maxit = 0.0;
    
    bool in_set = true;
    
   	for(int i = 0; i < 20; i++){
       	z = to_the_2(z) + c;
        
        if(length(z) > 2.0){
        	maxit = float(i);
            in_set = false;
        	break;
        }
    }
    
    if(in_set){
    	col = glitch_ball(vec2(x,y));
        col.rg += z;
    }
    
    col.b += maxit/50.0;
    
    col.a = 1.0;
    
    return col;
}
    
void main(){
    float x = UV.x * ratio;
    float y = UV.y;
	vec4 col = mandelbrot_glitch(x,y - 0.01 * cos(PI2 * time));
    
    col += 0.7 * mandelbrot_glitch(
    	x + 0.01 * cos(PI2 * time + 120.3 * y + 80.3 * x),
        0.5-y - 0.02 * cos(PI2 * time + 80.0 * y)
    );
    
    float horizon = 0.25;
    
    if(y < horizon){
    	col.r += 0.2 - y;
        col.b += 0.2 - y;
    } else {
    	float sun_fac = 0.1;
        sun_fac *= pow(length(vec2(x,y) - vec2(0.55, -0.2)),2.0) + 5.9;
    	col.r += 0.2* sun_fac;
        col.b += 0.1 * sun_fac;
    }
    
    gl_FragColor = col;
}
