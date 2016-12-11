// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float time;
uniform float ratio;
uniform vec2 smooth_mouse;

#define PI 3.1416
#define PI2 (2.0 * PI)

bool arr(float x, float y){
	float ay2 = abs(y - 0.5);
	return ay2 < x && ay2 > x - 0.5;
}

vec2 vhspos(vec2 pos, float t){
	float height_multiplier = distance(pos.y, 0.5);
	height_multiplier = pow(height_multiplier, 3.0 - 2.0 * cos(PI2 * time));
	
	pos.y += height_multiplier * 0.01 * sin(PI2 * t + 10.0 * pos.x);
	pos.x += height_multiplier * 0.07 * sin(PI2 * t + 13.0 * pos.x + 90.0 * pos.y);

    
	return pos;
}

float vhs(vec2 pos, float col, float t){
	float noise = 0.0;
    
    if(sin(690.0 * pos.y) < 0.1){
    	if(sin(35.0 * pos.y + PI2 *  time) < 0.2){
        	if(sin(50.0 * pos.y) < 0.2){
	    		float n = 0.4 * sin(pos.x * 30.0 + PI2 * time + pos.y * 30.0);
                n *= 1.0 + 0.1 * cos(pos.x * 4035.0 + PI2 * time);
                noise += n;
            }
        } else {
        	noise = 0.4 * sin(pos.x * pos.y);
        }
    }
    
    noise *= cos(4.0 * pos.x + PI2 * time);
   	    
    col += noise;
    
    col *= 1.0 + 0.1 * (sin(PI2 * time) + 0.1 * sin(4.0 * PI2 * time));

    col *= 1.0 - distance(pos, vec2(0.5 * ratio, 0.5));
    
    return col;
}

void main(void){
	float x = UV.x * ratio;
	float y = UV.y;
	
    vec2 pos = vec2(x,y);
    
    vec2 mod_pos = vhspos(pos + 0.3 * smooth_mouse, time);
    
    x = mod_pos.x;
    y = mod_pos.y;
    
	vec4 col = vec4(0.0);

	float y_num;

	y = y * 10.0;    
	y_num = y;
	y = mod(y, 1.0);

	if(mod(y_num, 2.0) < 1.0){
		x = -x * 10.0 + time;
	} else {
		x = x * 10.0 + time;
	}

	x = mod(x, 1.0);

	bool arrow = arr(x, y);

    if(y < 0.1){
		arrow = false;
	} else if(y > 0.9){
		arrow = false;
	}

	if(arrow){
		col = vec4(0.8, 0.8, 0.3, 1.0);
	} else {
		col = vec4(0.1);
	}

	col.r = vhs(pos, col.r, time);
   	col.g = vhs(pos, col.g, time + 0.2);
   	col.b = vhs(pos + vec2(0.01,0.003), col.g, time + 0.2);
	
	col.a = 1.0;
    
	gl_FragColor = col;
}
