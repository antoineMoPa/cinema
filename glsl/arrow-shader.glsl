// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float time;
uniform float ratio;
uniform vec2 mouse;

bool arr(float x, float y){
	float ay2 = abs(y - 0.5);
	return ay2 < x && ay2 > x - 0.5;
}

void main(void){
	float x = UV.x * ratio;
	float y = UV.y;

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

	col.a = 1.0;

	gl_FragColor = col;
}