// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float slowtime;
uniform float ratio;

void main(void){
    float x = (UV.x - 0.5)*3.0 * ratio;
    float y = (UV.y - 0.5)*3.0;
    
    highp vec2 z = vec2(x,y);
    highp vec2 c = vec2(0.285,mod(slowtime,1000.0));
    
    float maxit = 0.0;
    
    for(int i = 0; i < 20; i++){
        z = (z*mat2(z.x,-z.y,z.yx)) + 0.3 * sin(z * 3.0 * c * 3.1416 + 2.0) + c;

        if(length(z) > 2.0){
            maxit = float(i);
            break;
        }
    }
    
    gl_FragColor =
        vec4(
            sin(1.0*maxit/20.0)*0.7,
            cos(1.0 * maxit/2.0)*0.0,
            cos(maxit/10.0) * -0.1,
            1.0
            );
}
