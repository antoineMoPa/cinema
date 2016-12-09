// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float time;
uniform float ratio;
uniform vec2 mouse;

#define PI 3.1416
#define PI2 (3.1416 * 2.0)

vec4 stars(vec2 pos, float t){
    vec4 col = vec4(0.0);
    
    float fac = sin(-2.0 * (cos(143.0 * pos.x) + sin(20.0 * pos.y)));
    fac *= sin(-2.0 * (cos(43.4 * pos.x) + sin(132.0 * pos.y)));
    fac *= sin(-2.0 * (tan(23.4 * pos.x) + sin(12.0 * pos.y)));
    fac *= sin(-2.0 * (cos(33.2 * pos.x + 0.2 * cos(PI2 * t)) + sin(22.0 * pos.y)));
    fac *= cos(334.0 * pos.x +334.0 * pos.y);
    fac = pow(fac,4.0);
    
    float fac2 = abs(pow(fac, 2.0) + 0.1);
    
    col += fac2 * vec4(1.0);
    
    
    return col;
}

float curve(float t){
    t = mod(t,1.0);
    // 2^(1-4x^2)/2
    return pow(2.0,(1.0-pow(4.0*(t-0.5),2.0)))/2.0;
}

vec4 stars_zoom(vec2 pos, float t){
    vec4 col = vec4(0.0);
    
    pos -= 0.5;
    vec2 pos1 = pos * (3.0 - t);
    vec2 pos2 = pos * (3.5 - t);
    pos2.x += 0.41;
    vec2 pos3 = pos * (3.8 - t);
    pos3.x += 0.5;
    
    float fac1 = curve(t);
    float fac2 = curve(t+0.333);
    float fac3 = curve(t+0.666);
    
    col += fac1 * stars(pos1,0.4);
    col += fac2 * stars(pos2,0.3);
    col += fac3 * stars(pos3,0.2);
    //col = stars(pos,0.0);
    
    return col;
}


vec4 rect(vec2 v, float start, float width, vec4 color, float t){
    vec4 col = vec4(0.0);
    v.x -= 0.5;
    v.y -= 0.5;
    
    v.x = abs(v.x);
    
    v.y = v.y / (10.9 * v.x + 1.0);
    v.x = v.x / (3.9 * v.x + 1.0);
    
    v.y *= 3.0;
    
    if(v.x < 0.01){
        return col;
    }
    
    if(v.y > start && v.y < start + width){
        if(cos(50.0 * v.x - PI2 * t ) < 0.1){
            col += color * (0.2 + 0.9 * pow(2.0 * v.x,2.0));
        }
    }
    
    return col;
}

vec4 rects(float x, float y, float time){
    vec4 col = vec4(0.0);
    
    for(int i = 0; i < 20; i++){
        float seed = cos(0.3 * float(i) + tan(float(i)));
        float r = 0.5 + 0.1 * mod(seed, 1.0);
        float g = 0.4 * mod(seed + 0.2, 1.0);
        float b = 0.4 * mod(seed + 0.13, 1.0);
        
        col += rect(vec2(x, y),
		1.0 / 20.0 * float(i) - 0.5,
		0.02 + 0.04 * cos(seed) * r,
		vec4(r,g,b,0.0),
		time + seed
		);
        
    }
    
    col *= pow(5.0 * abs(2.0 * (x - 0.5)),1.0);
    
    return col;
}


void main(void){
    float x = UV.x * ratio;
    float y = UV.y;
    
    vec4 col = vec4(0.0);
    
    col = 1.4 * stars_zoom(vec2(x,y),time);
    col.r += 0.02 * cos(cos((1.0 - length(vec2(x,y) - 0.5)) * 2.0) + 0.8);
    col.b += 0.01 * cos(PI2 * time - cos((1.0 - length(vec2(x,y) - 0.5)) * 3.0));
    
    
    
    col += 0.3 * rects(x, y, time);
    
    vec4 vignette = col * pow(1.0 - distance(vec2(x, y), vec2(0.5, 0.5)),2.0);
    col = vignette;
    
    col.a = 1.0;
    
    gl_FragColor = col;
}