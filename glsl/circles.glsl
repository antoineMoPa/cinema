// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float time;
uniform float ratio;
uniform vec2 mouse;

#define PI 3.1416
#define PI2 (2.0*PI)

vec4 rainbowcol(int index){
    vec4 col;
    
    int i = int(mod(float(index),4.0));
    
    if(i == 0){
        col.rgb = vec3(0.9,0.0,0.0);
    } else if(i == 1){
        col.rgb = vec3(0.8,0.5,0.1);
    } else if(i == 2){
        col.rgb = vec3(0.2,0.5,0.4);
    } else if(i == 3){
        col.rgb = vec3(0.1,0.7,0.1);
    } else if(i == 4){
        col.rgb = vec3(0.1,0.2,0.8);
    }

    col.a = 1.0;
    return col;
}

vec4 rainbow(float x, float y, float time){
    vec4 col;
    
    // relative y
    float rely = mod(10.0*y,2.0);
    int bar = int(10.0*y/2.0);
    
    if(rely < sin(3.0 * PI * (0.1 * x + 0.2 * y) + time * PI2)/2.0 + 1.5){
            col = rainbowcol(bar);
    }
    
    return col;
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
    
    float angle = atan(y,x);
    
    x = angle;
    y = 10.0 * d;
    
    vec4 col = vec4(0.0,0.0,0.1,1.0);
    
    col += rainbow(x,y,time)/2.0;
    col += rainbow(x,y,time)/2.0;
    
    col *= vignette(d);
    
    col.a = 1.0;
    
    gl_FragColor = col;
}