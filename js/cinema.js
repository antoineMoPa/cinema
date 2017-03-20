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
            xhr.overrideMimeType('text/plain');
            xhr.onreadystatechange = function(e){
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

function parse_hooks(files){
    var filesObject = [];
    
    // Remove empty lines
    for(var f in files){
        var splitted = files[f].split(" ")
        filesObject.push({
            name: splitted[0],
            hooks: splitted[1] || null
        });
    }

    return filesObject;
}

load_file("glsl/list.txt", function(files){
    var files = files.split("\n");

    // Remove empty lines
    for(var f in files){
        if(files[f] == ""){
            files.splice(f, 1);
        }
    }
    
    files = parse_hooks(files);

    cinema(files);
});

function cinema(files){
    var current_file_index = 0;
    var current_script = null;
    var anim_len = 10;
    var anim_delay = 100;
    var frame = 0;
    var mouse = [0.0, 0.0];
    var smooth_mouse = [0.0, 0.0];
    var hooks;

    // The main canvas
    var canvas = qsa(".result-canvas")[0];
    var ratio;

    function resize(){
        var ww = window.innerWidth;
        var wh = window.innerHeight;
        canvas.width = ww;
        canvas.height = wh;
        ratio = canvas.width / canvas.height;
    }

    resize();

    window.addEventListener("resize", resize);

    var matches =
        window.location.href.match(
                /\?file\=([a-zA-Z0-9\/]+\.glsl)/
        );

    var res_ctx = canvas.getContext("webgl");

    var fragment_pre = qsa("pre[name='fragment']")[0];
    var fragment_error_pre = qsa(".fragment-error-pre")[0];
    var vertex_error_pre = qsa(".vertex-error-pre")[0];

    enable_mouse(canvas);

    function update_hooks(new_hooks){
        hooks = {};
        hooks.init = new_hooks.init || function(){};
        hooks.before_render = new_hooks.before_render || function(){};

        hooks.init = hooks.init(res_ctx);
    }

    // an alias
    window.update_hooks = function(nh){
        update_hooks(nh);
    };
    
    function next_file(){
        current_file_index++;
        current_file_index = current_file_index % (files.length - 1);
        load_current();
        add_to_history();
    }

    function prev_file(){
        current_file_index--;

        if(current_file_index < 0){
            current_file_index = files.length - 2;
        }

        current_file_index = current_file_index % (files.length - 1);
        load_current();
        add_to_history();
    }

    // Enable prev/next buttons
    qsa(".cinema-previous")[0].addEventListener("click", prev_file);
    qsa(".cinema-next")[0].addEventListener("click", next_file);
    
    function add_to_history(){
        // Add to browser history to enable
        // Back button
        var name = files[current_file_index].name;
        var url = window.location.href.replace(/\?.*$/,"");
        url += "?file=" + name;

        window.history.pushState(
            {index: current_file_index},
            name,
            url
        );
    }

    function load_current(){
        var title = qsa(".cinema-title a")[0];
        var name = files[current_file_index].name;
        var file_hooks = files[current_file_index].hooks;
        
        var url = window.location.href.replace(/\?.*$/,"");
        url += "?file=" + name;
        title.href = url;
        var indicator = (current_file_index + 1) + " of " + (files.length - 1);
        title.innerHTML = name + " [" + indicator + "]";
        load_file("./glsl/" + name, update_shader);

        var new_script = null;
        
        if(file_hooks != null){
            new_script = document.createElement("script");
            new_script.setAttribute("src", "glsl/" + file_hooks);
            new_script.setAttribute("type", "text/javascript");

            document.body.appendChild(new_script);
        }

    if(current_script != null){
            document.body.removeChild(current_script);
        }
    
        current_script = new_script;
    }

    window.onpopstate = function(event){
        var state = event.state;
        current_file_index = state.index || 0;
        load_current();
    };

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
        var time =
            parseFloat(
                ((new Date()).getTime() % 1000) / 1000
            );

        var timeAttribute = ctx.getUniformLocation(ctx.program, "time");
        ctx.uniform1f(timeAttribute, time);

        // Set time attribute
        var slow_time =
            parseFloat(
                ((new Date()).getTime() % 3000) / 3000
            );

        var slowTimeAttribute = ctx.getUniformLocation(ctx.program, "slowtime");
        ctx.uniform1f(slowTimeAttribute, slow_time);

        // Screen ratio
        var ratio = can.width / can.height;

        var ratioAttribute = ctx.getUniformLocation(ctx.program, "ratio");
        ctx.uniform1f(ratioAttribute, ratio);
        
        var widthAttribute = ctx.getUniformLocation(ctx.program, "width");
        ctx.uniform1f(widthAttribute, canvas.width);

        var heightAttribute = ctx.getUniformLocation(ctx.program, "height");
        ctx.uniform1f(heightAttribute, canvas.height); 
       
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
        
        if(typeof(hooks) != "undefined"){
            hooks.before_render(ctx);
        }
        
        ctx.drawArrays(ctx.TRIANGLE_STRIP, 0, 4);

        ctx.viewport(0, 0, can.width, can.height);

    }

    var vertex_code = load_script("vertex-shader");
    var fragment_code = "";

    var match = /\?file=(.*)/.exec(window.location.href);

    if(match != null){
        var name = match[1];
        var index = -1;

        var i = 0;
        
        while(i < files.length){
            if(files[i].name == name){
                index = i;
                break; 
            }
            i++;
        }

        current_file_index = index;
    } else {
        current_file_index = 0;
    }
    
    add_to_history();
    
    load_current();

    function draw(){
        draw_ctx(canvas, res_ctx);
        
        window.requestAnimationFrame(draw);
    }

    window.requestAnimationFrame(draw);
}
