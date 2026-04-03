// ZPR (Zap Portable Runtime) functions declarations
//ext fun println(s: String);
ext fun print(s: String);
ext fun eprintln(s: String);
ext fun eprint(s: String);

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
    
    freeFileContent(content);
    return true;
}
