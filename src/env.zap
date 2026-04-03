// ZPR (Zap Portable Runtime) functions declarations
//ext fun println(s: String);
ext fun print(s: String);
ext fun eprintln(s: String);
ext fun eprint(s: String);

ext fun slen(s: String) Int;
ext fun sindex(s: String, idx: Int) Char;
ext fun sslice(s: String, start: Int, end: Int) String;
ext fun streql(a: String, b: String) Bool;

struct StringResult {
    string: String,
    ok: Bool,
}

ext fun isError() Bool;

ext fun readFile(path: String) String;
ext fun freeFileContent(content: String);

// HM functions declarations
ext fun hmInit();
ext fun hmPut(key: String, value: String) Bool;
ext fun hmGet(key: String) String;

/// ENV functions declarations
/// ext fun envLoad(file: String) Bool;

fun envLoad(file: String) Bool {
    println(file);
    
    var content: String = readFile(file);
    if isError() {
        return false;
    }

    if slen(content) == 0 {
        eprintln("warning: file is empty");
        return true;
    }
   
    var i: Int = 0;
    var n: Int = slen(content);
    while i < n {
        var keyStart: Int = i;
        while i < n && sindex(content, i) != '=' && sindex(content, i) != '\n' {
            i = i + 1;
        }
        var keyEnd: Int = i;

        if i < n && sindex(content, i) == '=' {
            i = i + 1;
        }

        var valueStart: Int = i;
        while i < n && sindex(content, i) != '\n' {
            i = i + 1;
        }
        var valueEnd: Int = i;

        if i < n && sindex(content, i) == '\n' {
            i = i + 1;
        }

        var key: String = sslice(content, keyStart, keyEnd);
        var value: String = sslice(content, valueStart, valueEnd);
        println(key);
        println(value);
        if !hmPut(key, value) {
            eprintln("internal error");
            return false;
        }
    }

    freeFileContent(content);
    return true;
}
