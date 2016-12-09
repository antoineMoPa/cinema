// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float time;

void main(void){
    float x = UV.x;
    float y = UV.y;
	
	float star = 1.0;
	
	star *= cos(60.0 * x) + sin(3.1416 * 1.0 * time);
	star *= cos(60.0 * y) + sin(3.1416 * 2.0 * time + 3.1416);
	
	star = star - pow(star,5.0);
	star = star - pow(star, 3.0);
	star = pow(star, 0.4);    

    gl_FragColor =
        vec4(
			star,
            star,
			star,
            1.0
        );
}