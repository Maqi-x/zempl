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

// AP functions declarations
ext fun apGetInput() String;
ext fun apGetOutput() String;
ext fun apParse() Bool;

// ENV functions declarations
ext fun envLoad(file: String) Bool;

fun run() Int {
    hmInit();
    apParse();

    println(apGetInput());
    println(apGetOutput());
    println(hmGet("VERSION"));
    return 0;
}
