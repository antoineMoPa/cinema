// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float time;
uniform float slowtime;
uniform float ratio;
uniform vec2 mouse;

#define PI 3.1416
#define PI2 (3.1416 * 2.0)

vec4 stars(vec2 pos, float t){
    vec4 col = vec4(0.0);
	
    float fac = sin(-2.0 * (cos(23.0 * pos.x + 30.0 * pos.y) + sin(200.0 * pos.y)));
    fac *= sin(-2.0 * (cos(43.4 * pos.x + 44.0 * pos.y) + sin(132.0 * pos.y)));
    fac *= sin(-2.0 * (tan(43.4 * pos.x + 21.0 * pos.y) + sin(102.0 * pos.y)));
    fac *= sin(-2.0 * (cos(33.2 * pos.x + 0.2 * cos(PI2 * t)) + sin(222.0 * pos.y)));
    fac *= cos(334.0 * pos.x +334.0 * pos.y);
   	fac = pow(fac,4.0);
    
    float fac2 = abs(pow(fac, 2.0) + 0.1);
    
    col += fac2 * vec4(1.0);
   
    
	return col;	
}

float curve(float t){
    // 2^(1-20*(x-0.5)^2)/2
    return pow(2.0, (1.0 - 20.0 * pow((t - 0.5), 2.0) )) / 2.0;
}

vec4 stars_zoom(vec2 pos, float t){
    vec4 col = vec4(0.0);

    float t1 = t;
    float t2 = t - 0.5;

    float fac1 = curve(t);
    float fac2 = 1.0 - fac1;
    
    pos.x -= 0.5 * ratio;
    pos.y -= 0.5;
    
    vec2 pos1 = pos * (3.0 - t1);
    vec2 pos2 = pos * (3.6 - t2);

    pos2.x += 0.41;

    col += fac1 * stars(pos1, t1);
    col += fac2 * stars(pos2, t2);
         
	return col;	
}

void main(void){
    float x = UV.x * ratio;
    float y = UV.y;
    
    vec4 col = vec4(0.0);
    
    col = stars_zoom(vec2(x,y),time);
    col += 0.2 * stars_zoom(vec2(x,y),slowtime);
    
    col.r += 0.01 * cos(PI2 * slowtime -
                        cos((1.0 - length(vec2(x,y) - 0.5)) * 2.0) + 0.8);
    
   	col.b += 0.01 * cos(PI2 * slowtime -
                        cos((1.0 - length(vec2(x,y) - 0.5)) * 3.0));
    
    vec4 vignette = col *
        pow(1.0 - distance(vec2(x, y), vec2(0.5 * ratio, 0.5)),2.0);

    col.a = 1.0;
    
    gl_FragColor = col;
}
