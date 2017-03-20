// Fragment shader
precision highp float;

#define PI 3.14159265359
#define PI2 6.28318530718

varying vec2 UV;
varying vec3 v_position;
uniform float time;
uniform float slowtime;
uniform float ratio;
uniform vec2 mouse;

uniform sampler2D shellTex;

/*
  Complex square
*/
highp vec2 to_the_2(highp vec2 z){
    highp vec2 old_z;
    // Keep the current (old) value
    old_z = z;

    // Set new values according to math
    z.x = pow(z.x,2.0) - pow(z.y,2.0);
    z.y = 2.0 * old_z.x * old_z.y;

    return z;
}

vec4 mandelbrot(vec2 pos){
    float x = pos.x;
    float y = pos.y;
    
    vec4 col = vec4(0.0);
    vec2 c = vec2( -y + 0.5, x - 0.5);
    vec2 z = vec2(0.0, 0.0);
    c *= 10.0;
    c.x -= 0.5;
    float maxit = 0.0;

    bool in_set = true;

    for(int i = 0; i < 20; i++){
        z = to_the_2(z) + c;

        if(length(z) > 2.0){
            maxit = float(i);
            in_set = false;
            break;
        }
    }

    if(in_set){
        col.rg += 0.4;
    }

    col.b += maxit/50.0;

    col.a = 1.0;

    return col;
}

vec4 noise(vec2 pos){
    vec4 col = vec4(0.0);

    float random, other;

    col += 0.2 * (cos(random +  0.2 * other) + 0.5);
    col = pow(col, vec4(4.0));
    col += 0.3 * cos(1000.0 * other + pos.y * 100000.0);

    if(length(col) < 0.3){
        col *= 0.1;
    }

    return col;
}

vec4 shell(vec2 pos){
    vec4 col = vec4(0.0);

    float d = distance(pos, vec2(0.0, 0.0));

    vec2 border = pos;
    
    pos += 0.05 * pos * pow(d, 4.0);
    border += 0.3 * pos * pow(d, 4.0);
    
    if(border.x < -0.5 || border.x > 0.5 || border.y < -0.5 || border.y > 0.5){
        if(border.x < -0.56 || border.x > 0.56 || border.y < -0.56 || border.y > 0.56){
            return col;
        } else {
            col = vec4(0.4,0.38,0.24,1.0);
            col *= 0.1 + 0.2 * (d - 0.4);

            float dd = distance(pos, vec2(0.43,-0.506));
            
            if(dd < 0.02){
                if(dd < 0.003){
                    col += 0.1;
                }
                col += 0.06 * (1.0 - dd/0.02);
            }
            
            return col;
        }
    }
    
    col += 2.0 * texture2D(shellTex, border * vec2(1.0, -1.0) + vec2(-0.5, -0.5));
    
    col.r += 0.12 * floor(2.0 * abs(cos(300.0 * pos.x + 0.3) + 0.3));
    col.g += 0.04 * floor(2.0 * abs(cos(300.0 * pos.x + 2.5) + 0.3));
    col.b += 0.05 * floor(2.0 * abs(cos(300.0 * pos.x + 5.0) + 0.3));

    col *= cos(pos.y);
    col *= abs(cos(400.0 * pos.y + pos.x));

    col *= 1.0 - 4.0 * pow(d, 4.0);

    col *= 1.0 + 0.1 * noise(pos);
    col += 0.1 * noise(pos);
    
    col.a = 1.0;
    
    return col;
}


void main(void){
    float x = UV.x * ratio;
    float y = UV.y;

    vec4 col = vec4(0.0);

    vec2 pos = vec2(x - 0.5 * ratio, y - 0.5);

    pos *= 1.4;
    
    col += shell(pos);
    
    
    if(col.a < 0.01){
        if(pos.y > -0.1){
            float f1 = 0.05 * cos(2.0 * x + slowtime * PI2);
            float f2 = 0.05 * cos(2.2 * x + slowtime * PI2 + 1.4);
            float f3 = 0.04 * cos(2.3 * x + slowtime * PI2 + 1.9);
            float f4 = 0.03 * cos(2.3 * x + slowtime * PI2 + 2.6);
            
            if(f1 > pos.y){
                col.rgb += 0.2 * vec3(0.5, 0.1, 0.1);
            } else if (f2 > pos.y){
                col.rgb += 0.2 * vec3(0.1, 0.1, 0.3);
            } else if (f3 > pos.y){
                col.rgb += 0.2 * vec3(0.4, 0.1, 0.3);
            } else if (f4 > pos.y){
                col.rgb += 0.2 * vec3(0.4, 0.5, 0.1);
            }
        } else {
            float gradient = pos.y + 0.5 + 0.3 * abs(cos(pos.x));
            col.rgb += vec3(1.2 * pow(gradient,3.0),0.1 * gradient,0.3 * gradient);
        }
        float angle = atan(pos.y, pos.x);
        float ddd = distance(pos,vec2(0.0));
        col += 0.0001 * pow((ratio - ddd),10.0);
        col += 0.01 * pow((ratio - ddd),2.0);
        col += 0.004 * pow((cos(20.0 * angle + slowtime * PI2 + cos(10.0 * ddd + PI2 * slowtime)) + 0.5),2.0);
        pos += 0.01 * cos(col.r + slowtime * PI2 + col.g + 40.0 * pos.y);
        col = pow(col, 0.8 + 0.7 * mandelbrot((pos * vec2(0.1) + vec2(0.5, 0.48))));
        col *= 0.3;
    }
    
    col.a = 1.0;

    gl_FragColor = col;
}
