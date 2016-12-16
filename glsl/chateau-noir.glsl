// Fragment shader
precision highp float;

varying vec2 UV;
varying vec3 v_position;
uniform float time;
uniform float width;
uniform float height;
uniform float ratio;
uniform vec2 mouse;

#define PI2 6.28318530717958

float manhattan_distance(vec2 p1, vec2 p2){
    return abs(p1.y - p2.y) + abs(p1.x - p2.x);
}

#define VORO_SIZE 4

vec3 voronoi(float x, float y){
	vec2 points[VORO_SIZE];
    
    points[0] = vec2(1.6, 1.4);
    points[1] = vec2(0.1, 2.1);
    points[2] = vec2(0.0, 0.5);
    points[3] = vec2(0.1, 0.1);
    //points[4] = vec2(0.3, 0.3);
    //points[5] = vec2(1.4, 0.1);
    //points[6] = vec2(.5, 4.8);
    //points[7] = vec2(0.2, 0.2);
    //points[8] = vec2(0.5, 1.6);
    //points[9] = vec2(0.2, 1.2);
    
    vec2 pos = vec2(x, y);
    
    float d = 20000.0;
    
    int num = 0;
    
    for(int i = 0; i < VORO_SIZE; i++){
        points[i].x += 0.002 * cos(time * PI2 + float(i));
    }
    
    float px;
    float py;
    
    for(int i = 0; i < VORO_SIZE; i++){
        float d2 = distance(pos, points[i]);
        
        d2 = abs(cos(40.0 * d2));
        
        if(d2 < d){
            d = d2;
            num = i;
            px = points[i].x;
            py = points[i].y;
        }
    }
    
    return vec3(float(num), px, py);
}

float paint_fac(float x, float y){
	float ox = x;
    float oy = y;
    
	x *= 2.0 + 0.3 * cos(1.0 * x + 1.0 * y);
    y *= 3.0 + 0.2 * cos(1.0 * y + 3.0 * x);
    
	float fac = (1.0 
        + 0.1 * cos(
        	12.0 * y +
            cos(23.1 * y) +
            cos(34.4 * x)
        )
       	+ 0.01 * cos(42.0 * y)
    );
    
    fac = 1.0 + 0.3  * fac + 0.01 * cos(400.0 * ox) + 0.01 *  cos(400.0 * oy);
    
	return fac;
}

float jitter(float x){
	return sin(20.0 * x) + sin(10.0 * x + 0.7 * sin(time * PI2)) + 0.2 * sin(x + PI2 * time);
}

vec4 jitter(vec4 col, float x, float y){
	x = 3.0 * x;
    y = 3.0 * y;
    
	return col + 0.1 * (
    	sin(0.1 * x + 
        	0.1 * cos(20.0 * y + 0.4 * sin(time * PI2)) * cos(21.5 * x)) +
        		0.1 * sin(4.0 * x + PI2 * time) * col);
}

vec4 paint(float x, float y, vec4 paint){
    float fac = paint_fac(x, y);
    
    return paint * fac;
}

vec4 building(float x, float y){
	vec4 col = vec4(0.0);
    
    x *= 1.0 + 0.01 * jitter(x + 0.1 * y);
    y *= 1.0 + 0.01 * jitter(y + 0.1 * x);
    
    if(x < 0.6 && x > 0.21 && y < 0.7){
    	col += vec4(0.6,0.2,-0.3,1.0);
        // Windows
        if(x < 0.55 && x > 0.26 && sin(60.0 * x + 0.0) < 0.0){
        	float win_top = 0.01 * pow(1.0 - sin(60.0 * x + 0.0), 3.0) + 0.54;
            
        	if(y < win_top && y > 0.47)
	        	col -= vec4(0.24);
        }
    }
    
    return col;
}

void main(void){
    float x = UV.x * ratio;
    float y = UV.y;
    
    vec4 col = vec4(0.0);
    
    vec3 voro = voronoi(x, y);
    float num = voro.x;

    vec3 voro2 = voronoi(x * 3.0, y * 3.0);
    float num2 = voro2.x;
    float tex2 = num2 / float(VORO_SIZE);
    
    float px = voro.y;
    float py = voro.z;
    
    x -= 0.003 * cos(1.0 * num) + 0.003 * cos(80.0 * y);
    y -= 0.003 * cos(1.0 * num) + 0.003 * cos(80.0 * x);
    
    vec4 paint_blue = vec4(0.2, 0.35, 0.5, 1.0);
    vec4 paint_trees = vec4(0.04, 0.14, 0.1, 1.0);

    vec2 m = 0.05 * (mouse - vec2(0.5));
    float trees_x = 2.0 * m.x + x + 0.2;
    float trees_y = 2.0 * m.y + y;
    
    if(num == 2.0){
        paint_trees *= 0.7;
        paint_blue *= 1.1;
    }

    if(num == 1.0 || num2 == 1.0){
        // Trunk
        float func = pow((trees_x - 0.2) * 5.0, 2.0) - 0.1;

        if( trees_x > 0.2 &&
            abs(trees_y - func) < 0.02 &&
            trees_y < 0.5 ){
            paint_trees += 0.3 * vec4(0.6, 0.4, 0.2, 1.0);
        }
    }

    if(num < 8.0 && num2 == 1.0){
        paint_trees += 0.4 * vec4(0.4 * x, 0.4 * x, 0.0, 1.0);
    }

    paint_blue += building(x + 0.04 - m.x, y - m.y - 0.1);
    
    paint_blue += building(x - 0.35 - m.x, y + 0.1 - m.y);

    paint_blue += 0.01 + 0.02 * cos(3.4 * x + 1.2 * y + 2.0 + PI2 * time);
    
    vec4 paint_col = paint_blue;
    
    float mountain =
        0.0
        - 0.6 * (trees_x)
        + 0.05 * jitter(trees_x)
        + 0.01 * jitter(4.0 * (trees_y));
    
    float mountain_fac = pow(y - mountain, 15.0);
    
    if(mountain_fac > 1.0){
    	mountain_fac = 1.0;
    } else if (mountain_fac < 0.0){
    	mountain_fac = 0.0;
    }
    
  	paint_col =  
    	jitter(
        	(1.0 - mountain_fac) * paint_trees +
        	(mountain_fac) * paint_blue, x, y);
    
    col += paint(x, y, paint_col);

    col *= 1.0 + 0.04 * sin(1.6 * width * UV.x) + 0.04 * sin(1.6 * height * UV.y);
    
    float tex = num / float(VORO_SIZE);
    
    col.rgb += vec3(0.1 * tex);

    col.rgb += vec3(0.1 * tex2);
    
    col.a = 1.0;
    
    gl_FragColor = col;
}
