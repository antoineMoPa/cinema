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

vec4 blocks(int x, int y){
    vec4 col = vec4(0.0);
    float fx = float(x);
    float fy = float(y);

    if(cos(fx/2.0) * cos(fy/4.0) < 0.0){
        if(cos(fx / 5.0) * cos(fy / 3.0) < 0.0){
            if(cos(fx / 1.5) * cos(fy / 2.0) < 0.0){
                if(cos(fx/6.0) * cos(fy / 7.0) < 0.0){
                    if(cos(fx/5.0) * cos(fy / 8.0) < 0.0){
                        col.b = 1.0;
                        col.r = 0.1;
                        col.g = 0.1;
                        col.a = 1.0;
                    } else if (cos(fx/8.0) * cos(fy / 7.0) < 0.0) {
                        col.r = 0.9;
                        col.g = 0.8;
                        col.a = 1.0;
                    } else {
                        col.r = 1.0;
                        col.a = 1.0;
                    }
                }
            }
        }
    }
    
    return col;
}

vec4 bbw(int x, int y){
    float pi2t = PI2 * slowtime;    
    vec4 col = vec4(0.0);
    
    int color = 0;
    
    if(sini(30000 * x) + abs(sini(200 * x)) < 0.0){
    	// Yellow x
        color = 1;
    }
    
    if(sini(30000 * y) + abs(sini(200 * y)) < 0.0){
    	// Yellow y
    	color = 1;
    }
    
    if( (color == 1 || color == 2)){
        col = vec4(0.0, 0.0, 0.0, 1.0);
        
    	float blue = squares(x, y) - squares(x - 2, y - 1);
        
        if(blue < 0.4){
        	blue = 0.0;
            
            float red = squares(x - 2, y - 3);
            
            if(red < 0.2){
                float gray = squares(-x - 3, y - 4);
                gray += squares(-x - 4, y - 1);
                gray += squares(-x - 2, y - 1);
                gray += squares(-x - 4, y - 2);
                
                if(gray > 0.9){
                    col = gray * vec4(0.6, 0.6, 0.6, 1.0);
                }
            } else {
                col.r += red;
                col.g -= red;
                col.b -= red;
            }

            blue = 0.0;
        } else {
            col.b += blue;
            col.r -= 0.8 * blue;
            col.g -= 0.8 * blue;
        }

        if(col.r < 0.0){
            col.r = 0.0;
        }
        
        if(col.g < 0.0){
            col.g = 0.0;
        }
        
        if(col.b < 0.0){
            col.b = 0.0;
        }

        if(col.r + col.g + col.b < 0.3){
            col = vec4(1.0, 0.8, 0.0, 1.0);
        }
        
    } else {
        col = vec4(0.9, 0.9, 0.9, 1.0);
        vec4 blocks = blocks(x, y);
        col = blocks.a * blocks + (1.0 - blocks.a) * col;
    }

    return col;
}

void main(void){
    float xs = UV.x * ratio;
    float ys = UV.y;

    float size = 40.0;
    
    xs += smooth_mouse.x;
    ys += smooth_mouse.y;
    int x = int(floor(xs * size));
    int y = int(floor(ys * size));
    
    vec4 col = vec4(0.0);

    col += bbw(x, y);

    // edges detail
    vec2 square_pos = vec2(xs * size - float(x), ys * size - float(y));
    square_pos -= vec2(0.5, 0.5);
    col *= (1.0 - pow(length(1.0 * square_pos), 2.0)) * 0.1 + 0.9;

    // Some horizontal line shading
    if(square_pos.y > 0.4){
        vec4 other_col = bbw(x, y + 1);
        if(length(abs(other_col - col)) > 0.1){
            float pos = (square_pos.y - 0.4)/0.1;
            col = pos * other_col + (1.0 - pos) * col;
            col -= 0.1;
        }
    }
    
    col.a = 1.0;
    
    gl_FragColor = col;
}
