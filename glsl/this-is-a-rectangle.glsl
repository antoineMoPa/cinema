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
    
    vec2 z = vec2(0.0, 0.0);
    vec2 c = vec2(x - 0.5, y - 0.5);
	c *= 2.0;
    float maxit = 0.0;
    
   	for(int i = 0; i < 10; i++){
        
        float tf = 1.6 * cos(PI2 * time);
        
        float lz = length(z);
       	
        z += c;
		
        z += vec2(
        	lz * 0.8 * cos(z.x * 2.0),
			lz * 0.8 * cos(z.y * 4.0 + 0.1 * tf)
        );
		
        if(length(z) > 1.0){
        	maxit = float(i);
        	break;
        }
    }
    
    col.r = 1.4 - length(z);
    col.b = 1.0 - maxit/6.0;
    
    col.a = 1.0;
    
    gl_FragColor = col;
}