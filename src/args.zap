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

/// AP functions declarations
/// ext fun apGetInput() String;
/// ext fun apGetOutput() String;
/// ext fun apParse() Bool;

// argument parser implementation
global var input: String;
global var output: String;

fun apGetInput() String {
    return input;
}
fun apGetOutput() String {
    return output;
}

fun apParse() Bool {
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
        } else if streql(input, "") {
            input = arg;
        } else if streql(output, "") {
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
