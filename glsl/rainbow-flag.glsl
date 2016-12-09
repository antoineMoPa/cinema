// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float time;
uniform float ratio;
uniform vec2 mouse;

#define PI 3.1416
#define PI2 (2.0*PI)

float pixelize(float x){
    return floor(x * 20.0)/20.0;
}

vec4 rainbowcol(int index){
    vec4 col;
    
    if(index == 0){
        col.rgb = vec3(0.9,0.0,0.0);
    } else if(index == 1){
        col.rgb = vec3(0.8,0.5,0.1);
    } else if(index == 2){
        col.rgb = vec3(0.2,0.5,0.4);
    } else if(index == 3){
        col.rgb = vec3(0.1,0.7,0.1);
    } else if(index == 4){
        col.rgb = vec3(0.1,0.2,0.8);
    }

    col.a = 1.0;
    return col;
}

vec4 rainbow(float x, float y, float time){
    vec4 col;
    float original_y = y;
    y += 0.04 * cos(3.0 * x + PI2 * time);
    
    // relative y
    float rely = mod(10.0*y,2.0);
    int bar = int(10.0*y/2.0);
    
    if(pixelize(rely)+ 0.1 * cos(4.0 * x+ time * PI2) < sin(30.0 * x + time * PI2)/5.0 + 1.5){
        if(pixelize(rely) > sin(30.0 * x + 1.0 + time * PI2)/4.0 + 0.5){
            col = rainbowcol(bar);
            col += 0.1 * cos(2.0 * x);
            col += 0.4 * pixelize(0.3 * cos(10.0 * x));
            col += 0.4 * pixelize(0.3 * cos(10.0 * original_y));
        }
    }
    
    return col;
}

vec2 screenglitch(float x,float y, float time){
    vec2 pos = vec2(x,y);
    
    if(time > 0.3 && time < 0.8){
        float timefac = sin(PI2 * (time - 0.3)/0.5);
        float screenfac = pow(distance(vec2(x,y),vec2(0.5,0.5)),3.0);
        pos.x += screenfac * 0.3 * timefac * cos(20.0 * pos.y);
    }
    
    return pos;
}


float vignette(float d){
    return 1.0 - pow(d,2.0);
}

/*
    t: threshold
*/
bool is_border(vec2 uv, float t){
    
    if(uv.x < t){
        return true;
    }
    if(uv.x > 1.0 - t){
        return true;
    }
    if(uv.y < t){
        return true;
    }
    if(uv.y > 1.0 - t){
        return true;
    }

    return false;
}

void main(void){
    float x = UV.x;
    float y = UV.y;
    
    float d = distance(vec2(x,y),vec2(0.5,0.5));
    
    vec2 xy = screenglitch(x, y, time);
    
    x = xy.x;
    y = xy.y;
    
    vec4 col = vec4(0.1,0.0,0.1,1.0);
    
    col += rainbow(x,y,time)/2.0;
    col += rainbow(x-0.02,y,time)/2.0;
    
    if(is_border(xy, 0.02)){
        col.rgb *= 0.8;
    }
    
    if(is_border(xy, 0.01)){
        col.rgb *= 0.4;
    }
    
    col *= vignette(d);
    
    col.a = 1.0;
    
    gl_FragColor = col;
}