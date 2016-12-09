
// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float time;
uniform float ratio;
uniform vec2 mouse;

void main(void){
    float x = UV.x * ratio - 0.5;
    float y = UV.y - 0.5;

    vec4 col = vec4(0.0);
    
    float timec = 0.2 * cos(time * 2.0 * 3.1416) + 1.0;

	// Inspired by: imgur.com/a/EHYnQ
    
    col.r = abs(float(mod((100.0 * timec * x), (100.0 * y)))/30.0);
    col.b = abs(float(mod(-(100.0 * x), (timec * 50.0 * y)))/30.0);
    col.a = 1.0;
    
    gl_FragColor = col;
}