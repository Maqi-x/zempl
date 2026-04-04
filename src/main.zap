// ZPR (Zap Portable Runtime) functions declarations
//ext fun println(s: String);
ext fun print(s: String);
ext fun eprintln(s: String);
ext fun eprint(s: String);

ext fun slen(s: String) Int;
ext fun sindex(s: String, idx: Int) Char;
ext fun sslice(s: String, start: Int, end: Int) String;
ext fun streql(a: String, b: String) Bool;

ext fun readFile(path: String) String;
ext fun freeFileContent(content: String);

ext fun getArgCount() Int;
ext fun getArg(index: Int) String;

ext fun isError() Bool;
ext fun setError(v: Bool);

// HM functions declarations
ext fun hmInit();
ext fun hmPut(key: String, value: String) Bool;
ext fun hmGet(key: String) String;

// AP functions declarations
ext fun apGetUndefinedVarBehavior() UndefinedVarBehavior;
ext fun apGetInput() String;
ext fun apGetOutput() String;
ext fun apParse() Bool;

enum UndefinedVarBehavior {
    Ignore,
    Warn,
    Error,
    Empty
}

// DTB functions declarations
ext fun dtbInit(initCap: Int) Bool;
ext fun dtbPushString(s: String) Bool;
ext fun dtbPushChar(c: Char) Bool;
ext fun dtbGetString() String;
ext fun dtbClear();
ext fun dtbFree();

enum TeState {
    Text,
    Var
}

fun handleUndefinedVariable() Bool {
    var behavior: UndefinedVarBehavior = apGetUndefinedVarBehavior();
    if behavior == UndefinedVarBehavior.Ignore {
        dtbPushChar('@');
        dtbPushString(varName);
        dtbPushChar('@');
    } else if behavior == UndefinedVarBehavior.Warn {
        eprint("warning: undefined variable ");
        eprintln(varName);
    } else if behavior == UndefinedVarBehavior.Error {
        eprint("error: undefined variable ");
        eprintln(varName);
        return false;
    } else if behavior == UndefinedVarBehavior.Empty {
        // noop
    }
    return true;
}

fun templateEngine(input: String) Bool {
    dtbInit(slen(input));

    var state: TeState = TeState.Text;
    var i: Int = 0;
    var varStart: Int = 0;
    while i < slen(input) {
        var c: Char = sindex(input, i);
        if state == TeState.Text {
            if c == '@' {
                // @@ -> @
                if i + 1 < len && sindex(input, i + 1) == '@' {
                    dtbPushChar('@');
                    i = i + 1;
                } else {
                    state = TeState.Var;
                    varStart = i + 1;
                }
            } else {
                dtbPushChar(c);
            }
        } else if state == TeState.Var {
            if c == '@' {
                var varName: String = sslice(input, varStart, i);
                var value: String = hmGet(varName);
                if isError() {
                    if !handleUndefinedVariable() {
                        return false;
                    }
                } else {
                    dtbPushString(value);
                }
                state = TeState.Text;
            }
        }
        i = i + 1;
    }

    if state == TeState.Var {
        dtbPushChar('@');
        dtbPushString(sslice(input, varStart, slen(input)));
    }

    return true;
}

fun saveOutput(file: String) Bool {
    // TODO
    println(dtbGetString());
}

fun run() Int {
    hmInit();
    apParse();

    var inputFile: String = apGetInput();
    var outputFile: String = apGetOutput();

    var inputContent: String = readFile(inputFile);
    templateEngine(inputContent);
    freeFileContent(inputContent);

    saveOutput(outputFile);

    return 0;
}
