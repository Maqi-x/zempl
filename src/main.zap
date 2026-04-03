// ZPR (Zap Portable Runtime) functions declarations
//ext fun println(s: String);
ext fun print(s: String);
ext fun eprintln(s: String);
ext fun eprint(s: String);

ext fun getArgCount() Int;
ext fun getArg(index: Int) String;

fun run() Int {
    var i: Int = 0;
    while i < getArgCount() {
        println(getArg(i));
        i = i + 1;
    }
    return 0;
}
