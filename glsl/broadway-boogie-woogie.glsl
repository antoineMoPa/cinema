// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float slowtime;
uniform float ratio;
uniform vec2 mouse;
uniform vec2 smooth_mouse;

#define PI2 6.28318530718

float sini(int i){
	return sin(float(i));
}

float squares(int x, int y){
    float fx = float(x);
    float fy = float(y);
    float num = sin(fx * 2.0 * fy * 0.3+ PI2 * slowtime);
	
    num *= cos(fx);
    num *= cos(fx * 3.0);
    
    if(num < 0.0){
    	num = 0.0;
    }
    
    return num;
}

void main(void){
    float xs = UV.x * ratio;
    float ys = UV.y;
    float pi2t = PI2 * slowtime;

    xs += smooth_mouse.x;
    ys += smooth_mouse.y;
    
    vec4 col = vec4(0.0);
    
    int color = 0;
    
    float size = 40.0;
    
    int x = int(floor(xs * size));
    int y = int(floor(ys * size));
    
    if(sini(30000 * x) + abs(sini(200 * x)) < 0.0){
    	// Yellow x
        color = 1;
    }
    
    if(sini(30000 * y) + abs(sini(200 * y)) < 0.0){
    	// Yellow y
    	color = 1;
    }
    
    if( (color == 1 || color == 2)){
        col = vec4(0.9, 0.8, 0.1, 1.0);
        
    	float blue = squares(x, y) - squares(x - 2, y - 1);
       	
        if(blue < 0.4){
        	blue = 0.0;
            
        	float red = squares(x - 2, y - 3);
            col.r += red;
            col.g -= red;
            col.b -= red;
        } else {
        	blue = 1.0;
        }
        
    	col.b += blue;
        col.r -= blue;
        col.g -= blue;
    } else {
        col = vec4(0.9, 0.9, 0.9, 1.0);
    }
    
    col.a = 1.0;
    
    gl_FragColor = col;
}
