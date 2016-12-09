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
    vec4 col = vec4(0.0);
    float original_y = y;
    y += 0.04 * cos(3.0 * x + PI2 * time);
    
    // relative y
    float rely = mod(10.0*y,2.0);
    int bar = int(10.0*y/2.0);
    
    if(rely+ 0.1 * cos(4.0 * x+ time * PI2) < sin(30.0 * x + time * PI2)/5.0 + 1.5){
        if(rely > sin(30.0 * x + 1.0 + time * PI2)/4.0 + 0.5){
            col = rainbowcol(bar);
        }
    }
    
    return col;
}

void main(void){
    float x = UV.x;
    float y = UV.y;
    
    vec2 xy = vec2(x,y);
    
    float d = distance(vec2(x,y),vec2(0.5,0.5));
    
    vec4 col = vec4(0.0,0.0,0.1,1.0);
    
    col += rainbow(x,y,time);
    col.a = 1.0;
    
    gl_FragColor = col;
}