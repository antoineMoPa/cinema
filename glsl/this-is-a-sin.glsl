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
    vec2 s = vec2(x - 0.5,y - 0.5);
    z = s;
    z *= 4.0;
    float maxit = 0.0;
    
   	for(int i = 0; i < 10; i++){
    	float c = 4.0;
        
        float tf = 1.0 * cos(PI2 * time);
        
        //z += pow(z, vec2(2.0));
        //z += s;
        
        z.x += length(z) * 
        	(sin(c * z.x) + sin(tf * z.y));
        z.y += length(z) * 
        	(sin(c * z.x) + sin(c * z.y));
        
        if(length(z) > 1.0){
        	maxit = float(i);
        	break;
        }
    }
    
    //col.rg = z;
    col.b = maxit/6.0;
    
    col.a = 1.0;
    
    gl_FragColor = col;
}