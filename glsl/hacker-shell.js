(function (){
    var hooks = {};
    var can,ctx,tex;
    var message = "hacker@localhost:~$ ";

    var w = 512;
    var h = 512;
    var update_index = 0;

    var whatever = "ASCII  is the American Standard Code for Information Interchange.  It is a 7-bit\n       code.  Many 8-bit codes (e.g., ISO 8859-1) contain ASCII as  their  lower  half.\n       The international counterpart of ASCII is known as ISO 646-IRV.\n\n       The following table contains the 128 ASCII characters.\n\n       C program '\X' escapes are noted.\n\n       Oct   Dec   Hex   Char                        Oct   Dec   Hex   Char\n       ────────────────────────────────────────────────────────────────────────\n       000   0     00    NUL '\0' (null character)   100   64    40    @\n       001   1     01    SOH (start of heading)      101   65    41    A\n       002   2     02    STX (start of text)         102   66    42    B\n       003   3     03    ETX (end of text)           103   67    43    C\n       004   4     04    EOT (end of transmission)   104   68    44    D\nNAME\n       man - an interface to the on-line reference manuals\n\nSYNOPSIS\n       man  [-C  file]  [-d]  [-D]  [--warnings[=warnings]]  [-R  encoding]  [-L  locale] [-m system[,...]] [-M path] [-S list] [-e extension] [-i|-I] [--regex|--wildcard]\n       [--names-only] [-a] [-u] [--no-subpages] [-P  pager]  [-r  prompt]  [-7]  [-E  encoding]  [--no-hyphenation]  [--no-justification]  [-p  string]  [-t]  [-T[device]]\n       [-H[browser]] [-X[dpi]] [-Z] [[section] page ...] ...\n       man -k [apropos options] regexp ...\n       man -K [-w|-W] [-S list] [-i|-I] [--regex] [section] term ...\n       man -f [whatis options] page ...\n       man  -l  [-C file] [-d] [-D] [--warnings[=warnings]] [-R encoding] [-L locale] [-P pager] [-r prompt] [-7] [-E encoding] [-p string] [-t] [-T[device]] [-H[browser]]\n       [-X[dpi]] [-Z] file ...\n       man -w|-W [-C file] [-d] [-D] page ...\n       man -c [-C file] [-d] [-D] page ...\n       man [-?V]\n\nDESCRIPTION\n       man is the system's manual pager.  Each page argument given to man is normally the name of a program, utility or function.  The manual page associated with each  of\n       these  arguments  is then found and displayed.  A section, if provided, will direct man to look only in that section of the manual.  The default action is to search\n       in all of the available sections following a pre-defined order ( n l 8 3 2 3posix 3pm 3perl 5 4 9 6 7 by default, unless overridden by the SECTION  directive  in\n       /etc/manpath.config), and to show only the first page found, even if page exists in several sections.\n\n       The table below shows the section numbers of the manual followed by the types of pages they contain.\n\n       1   Executable programs or shell commands\n       2   System calls (functions provided by the kernel)\n       3   Library calls (functions within program libraries)\n       4   Special files (usually found in /dev)\n       5   File formats and conventions eg /etc/passwd\n       6   Games\n       7   Miscellaneous (including macro packages and conventions), e.g. man(7), groff(7)\n       8   System administration commands (usually only for root)\n       9   Kernel";

    var colors = [
        "#33aa11",
        "#aa3311",
        "#aaee11"
    ];

    var current_text_color = colors[0];

    var x = 4;
    var y = 30;
    
    function update_texture(gl){
        ctx.fillStyle = current_text_color;
        ctx.font = "17px monospace";

        ctx.fillText(message[0], x, y);
        x += 20;
        
        if(x > 450){
            x = 4;
            y += 30;
        }

        if(y > 450){
            x = 4;
            y = 30;
            message = "";
            ctx.clearRect(0,0,w,h);
        }

        // Remove already read part
        message = message.substr(1, message.length);
        
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, can);
        update_index++;
    }
    
    hooks.init = function(gl){
        can = document.createElement("canvas");
        ctx = can.getContext("2d");
        can.width = w;
        can.height = h;
        
        tex = gl.createTexture();
        gl.bindTexture(gl.TEXTURE_2D, tex);

        update_texture(gl);
        
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
        
        gl.bindTexture(gl.TEXTURE_2D, null);

        setInterval(function(){
            update_texture(gl);
        }, 30);

        setInterval(function(){
            var start = Math.floor(Math.random() * whatever.length - 30);
            message += whatever.substr(start, 30);
        }, 1000);

        // Change color some times
        setInterval(function(){
            current_text_color = colors[Math.floor(Math.random() * colors.length)];
        },1300);
        
    }
    
    hooks.before_render = function(gl){
        gl.activeTexture(gl.TEXTURE0);
        gl.bindTexture(gl.TEXTURE_2D, tex);
        gl.uniform1i(gl.getUniformLocation(gl.program, 'shellTex'), 0);
    }

    update_hooks(hooks);
})();


