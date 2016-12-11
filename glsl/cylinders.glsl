// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float time;
uniform float ratio;
uniform vec2 mouse;

#define PI 3.1416
#define PI2 (2.0 * PI)

vec4 cyl(float x, float y){
	vec4 col = vec4(0.0);
    
    float cylinder = 0.0;
    float curr_cylinder = 0.0;
    
    curr_cylinder = floor(x * 2.0 * PI + PI/2.0);
    
    cylinder = abs(cos(20.0 * x));
   	
    float offset = cos(PI2 * time + 0.3 * curr_cylinder);
    
    float middle = y * 20.0 - 10.0;
    
    if(curr_cylinder / 10.0 - offset < middle - 0.1 * cylinder){
		col = vec4(0.2, 0.1, 0.2, 1.0);
	} else if (curr_cylinder / 10.0 - offset < middle + 0.1 * cylinder){
    	// do nothing
        col = vec4(0.1, 0.1, 0.3,1.0);
    } else {
		col.r = cylinder -  0.07 * curr_cylinder * cos(30.6 * x);
        col.g = 0.1 * cos(y) + 0.1 * cos(PI2 * time + 60.0 * x);
		col.b = cylinder * 0.3;
    	col *= 0.3;
    }
    col = abs(col);
    return col;
}

void main(void){
    float x = UV.x * ratio;
    float y = UV.y;
    
    vec4 col = vec4(0.0);
    
    
    for(int i = 0; i < 4; i++){
    	col += 1.5 * 
        	cyl(x + 0.1 * float(i),
        	y - 0.046 * float(i));
        col *= pow(col,vec4(0.5));
        col.r -= 0.1 * col.r;
    }
    
    col.a = 1.0;
    
    gl_FragColor = col;
}
