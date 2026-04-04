// ZPR (Zap Portable Runtime) functions declarations
//ext fun println(s: String);
ext fun print(s: String);
ext fun eprintln(s: String);
ext fun eprint(s: String);

ext fun streql(a: String, b: String) Bool;

ext fun getArgCount() Int;
ext fun getArg(index: Int) String;

// HM functions declarations
ext fun hmInit();
ext fun hmPut(key: String, value: String) Bool;
ext fun hmGet(key: String) String;

// ENV functions declarations
ext fun envLoad(file: String) Bool;

/// AP functions declarations
/// ext fun apGetInput() String;
/// ext fun apGetOutput() String;
/// ext fun apParse() Bool;

// argument parser implementation
enum UndefinedVarBehavior {
    Ignore,
    Warn,
    Error,
    Empty,
}

global var input: String;
global var output: String;
global var outputSpecified: Bool;

global var undefVarBehavior: UndefinedVarBehavior;

fun apGetInput() String {
    return input;
}
fun apGetOutput() String {
    return output;
}
fun apGetUndefinedVarBehavior() UndefinedVarBehavior {
    return undefVarBehavior;
}

fun apParseUndefVarBehavior(s: String) Bool {
    if streql(s, "ignore") {
        undefVarBehavior = UndefinedVarBehavior.Ignore;
        return true;
    } else if streql(s, "warn") {
        undefVarBehavior = UndefinedVarBehavior.Warn;
        return true;
    } else if streql(s, "error") {
        undefVarBehavior = UndefinedVarBehavior.Error;
        return true;
    } else if streql(s, "empty") {
        undefVarBehavior = UndefinedVarBehavior.Empty;
        return true;
    }
    return false;
}

fun apApplyDefaults() {
    input = "";
    output = "-";
    outputSpecified = false;
    undefVarBehavior = UndefinedVarBehavior.Warn;
}

fun apParse() Bool {
    apApplyDefaults();
    var i: Int = 1;
    while i < getArgCount() {
        var arg: String = getArg(i);
        if streql(arg, "-D") {
            if !(i+2 < getArgCount()) {
                eprintln("Invalid usage of -D");
                return false;
            }

            i = i + 1;
            var key: String = getArg(i);
            i = i + 1;
            var value: String = getArg(i);

            if (!hmPut(key, value)) {
                eprintln("Internal error");
                return false;
            }
        } else if streql(arg, "--env") || streql(arg, "-E") {
            i = i + 1;
            if !(i < getArgCount()) {
                eprintln("Missing filepath for --env");
                return false;
            }
            var filepath: String = getArg(i);

            if !envLoad(filepath) {
                eprint("Failed to load env file: ");
                eprintln(filepath);
                return false;
            }
        } else if streql(arg, "--on-undef-var") || streql(arg, "-U") {
            i = i + 1;
            if !(i < getArgCount()) {
                eprintln("Missing value for --on-undef-var");
                return false;
            }
            var val: String = getArg(i);
            if !apParseUndefVarBehavior(val) {
                eprint("Invalid value for --on-undef-var: ");
                eprintln(val);
                return false;
            }
        } else if streql(input, "") {
            input = arg;
        } else if streql(output, "") || !outputSpecified {
            output = arg;
        } else {
            eprint("Unexpected argument: ");
            eprintln(arg);
            return false;
        }

        i = i + 1;
    }
    return true;
}
