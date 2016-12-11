/*
  Resources: 
  
  * https://gist.github.com/mbostock/5440492
  * http://memfrag.se/blog/simple-vertex-shader-for-2d
  * https://www.opengl.org/wiki/Data_Type_%28GLSL%29#Vector_constructors
  * https://www.opengl.org/wiki/Built-in_Variable_%28GLSL%29
  * https://www.khronos.org/registry/gles/specs/2.0/GLSL_ES_Specification_1.0.17.pdf

  */

function load_file(filename, callback){
    // Fetch file and put it in textarea
    if(filename != ""){
        try{
            var xhr = new XMLHttpRequest;
            xhr.open('GET', "./" + filename, true);
            xhr.onreadystatechange = function(){
                if (4 == xhr.readyState) {
                    var val = xhr.responseText;
                    callback(val);
                }
            };
            xhr.send();
        } catch (e){
            // Do nothing
        }
    }
}

load_file("glsl/list.txt", function(files){
    cinema(files.split("\n"));
});

function cinema(files){
    var current_file_index = 0;
    var current_file_name = files[0];
    
    var anim_len = 10;
    var anim_delay = 100;
    var frame = 0;
    var mouse = [0.0, 0.0];
    var smooth_mouse = [0.0, 0.0];
    
    // The main canvas
    var canvas = qsa(".result-canvas")[0];
    var ww = window.innerWidth;
    var wh = window.innerHeight;
    canvas.width = ww;
    canvas.height = wh;
    
    var matches =
        window.location.href.match(
                /\?file\=([a-zA-Z0-9\/]+\.glsl)/
        );
    
    var ratio = canvas.width / window.height;
    
    var res_ctx = canvas.getContext("webgl");
    
    var fragment_pre = qsa("pre[name='fragment']")[0];
    var fragment_error_pre = qsa(".fragment-error-pre")[0];
    var vertex_error_pre = qsa(".vertex-error-pre")[0];
    
    enable_mouse(canvas);

    function next_file(){
        current_file_index++;
        current_file_index = current_file_index % files.length;
        load_current();
    }

    function load_current(){
        var title = qsa(".cinema-title a")[0];
        var name = files[current_file_index];
        var url = window.location.href.replace(/\?.*$/,"");
        url += "?file=" + name;
        title.href = url;
        
        title.innerHTML = name;
        load_file("./glsl/" + name, update_shader);
    }
    
    canvas.addEventListener("click", function(){
        next_file();
    });
    
    function enable_mouse(can){
        can.hover = false;
        
        mouse = [can.width / 2.0, can.height / 2.0];
        smooth_mouse = [0.5, 0.5];
        
        can.addEventListener("mouseenter", function(e){
            can.hover = true;
            mouse = [can.width / 2.0, can.height / 2.0];
        });
        
        can.addEventListener("mousemove", setMouse);
        
        function setMouse(e){
            var x, y;
            
            x = e.clientX
                - can.offsetLeft
                - can.offsetParent.offsetLeft
                + window.scrollX;
            y = e.clientY
                - can.offsetTop
                - can.offsetParent.offsetTop
                + window.scrollY;
            
            mouse = [x, y];
        }
        
        can.addEventListener("mouseleave", function(){
            can.hover = false;
            mouse = [can.width / 2.0, can.height / 2.0];
        });
    }
    
    init_ctx(res_ctx);
    
    function init_ctx(ctx){
        ctx.clearColor(0.0, 0.0, 0.0, 1.0);
        ctx.enable(ctx.DEPTH_TEST);
        ctx.depthFunc(ctx.LEQUAL);
        ctx.clear(ctx.COLOR_BUFFER_BIT | ctx.DEPTH_BUFFER_BIT);
        
        // Triangle strip for whole screen square
        var vertices = [
                -1,-1,0,
                -1,1,0,
            1,-1,0,
            1,1,0,
        ];
        
        var tri = ctx.createBuffer();
        ctx.bindBuffer(ctx.ARRAY_BUFFER,tri);
        ctx.bufferData(ctx.ARRAY_BUFFER, new Float32Array(vertices), ctx.STATIC_DRAW);
    }

    function update_shader(val){
        fragment_code = val;
        fragment_pre.innerText = val;
        init_program(res_ctx);
    }
    
    function init_program(ctx){
        ctx.program = ctx.createProgram();
        
        var vertex_shader =
            add_shader(ctx.VERTEX_SHADER, vertex_code);
        
        var fragment_shader =
            add_shader(ctx.FRAGMENT_SHADER, fragment_code);
        
        function add_shader(type,content){
            var shader = ctx.createShader(type);
            ctx.shaderSource(shader,content);
            ctx.compileShader(shader);
            
            // Find out right error pre
            var type_pre = type == ctx.VERTEX_SHADER ?
                vertex_error_pre:
                fragment_error_pre;
            
            if(!ctx.getShaderParameter(shader, ctx.COMPILE_STATUS)){
                var err = ctx.getShaderInfoLog(shader);
                
                // Find shader type
                var type_str = type == ctx.VERTEX_SHADER ?
                    "vertex":
                    "fragment";
                
                type_pre.textContent =
                    "Error in " + type_str + " shader.\n" +
                    err;
            } else {
                type_pre.textContent = "";
            }
            
            ctx.attachShader(ctx.program, shader);
            return shader;
        }
        
        ctx.linkProgram(ctx.program);
        
        if(!ctx.getProgramParameter(ctx.program, ctx.LINK_STATUS)){
            console.log(ctx.getProgramInfoLog(ctx.program));
        }
        
        ctx.useProgram(ctx.program);
        
        var positionAttribute = ctx.getAttribLocation(ctx.program, "position");
        
        ctx.enableVertexAttribArray(positionAttribute);
        ctx.vertexAttribPointer(positionAttribute, 3, ctx.FLOAT, false, 0, 0);
        
    }
    
    function draw_ctx(can, ctx, time){
        // Set time attribute
        var tot_time = anim_len * anim_delay;
        
        var time = time ||
            parseFloat(
                ((new Date()).getTime() % tot_time)
                    /
                    tot_time
            );
        
        var timeAttribute = ctx.getUniformLocation(ctx.program, "time");
        ctx.uniform1f(timeAttribute, time);
        
        // Screen ratio
        var ratio = can.width / can.height;
        
        var ratioAttribute = ctx.getUniformLocation(ctx.program, "ratio");
        ctx.uniform1f(ratioAttribute, ratio);
        
        // Mouse
        var x = mouse[0] / can.width * ratio;
        var y = - mouse[1] / can.height;
        var mouseAttribute = ctx.getUniformLocation(ctx.program, "mouse");
        ctx.uniform2fv(mouseAttribute, [x, y]);
        
        // Smooth mouse
        if(can.hover == true){
            smooth_mouse[0] = 0.9 * smooth_mouse[0] + 0.1 * x;
            smooth_mouse[1] = 0.9 * smooth_mouse[1] + 0.1 * y;
        }
        
        var smAttribute = ctx.getUniformLocation(
            ctx.program, "smooth_mouse"
        );
        
        ctx.uniform2fv(smAttribute, smooth_mouse);
        
        ctx.drawArrays(ctx.TRIANGLE_STRIP, 0, 4);
        
        ctx.viewport(0, 0, can.width, can.height);
        
    }
    
    var vertex_code = load_script("vertex-shader");
    var fragment_code = "";

    var match = /\?file=(.*)/.exec(window.location.href);

    if(match != null){
        var name = match[1];
        var index = files.indexOf(name);
        current_file_index = index;
    }
    
    load_current();
    
    function draw(){
        draw_ctx(canvas, res_ctx);
        
        window.requestAnimationFrame(draw);
    }
    
    window.requestAnimationFrame(draw);
}
