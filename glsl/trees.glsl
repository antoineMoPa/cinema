// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float time;
uniform float ratio;
uniform vec2 mouse;

#define PI 3.1416
#define PI2 (2.0 * PI)
void main(void){
    float x = UV.x * ratio;
    float y = UV.y;
    
    vec4 col = vec4(0.0);
   
    float lastbranch = 0.5;
    
    for(int i = 0; i < 7; i++){
 		float width = 0.001 * pow(float(i),1.4);
    	float branch = 
        	cos(
            	(30.14 * lastbranch) * x + 0.1 * float(i) - 2.0 * PI * time - 0.5
			) * (y + 0.04 * float(i)) - 0.1;
		if (y < 0.1 * float(i) + 0.1){
    		if(abs(branch) < width){
        		col = vec4(x, y, pow(30.0 * branch,2.0), 1.0);
        	}
    	}

		lastbranch = branch;
	}
    
    col.a = 1.0;
    
    gl_FragColor = col;
}