#include <stddef.h>
#include <assert.h>
#include <string.h>
#include <stdio.h>

typedef long usize;

typedef struct ZapString {
    const char* ptr;
    usize len;
} ZapString;

void print(ZapString s) {
    fwrite(s.ptr, s.len, 1, stdout);
}
void eprint(ZapString s) {
    fwrite(s.ptr, s.len, 1, stderr);
}

void println(ZapString s) {
    print(s);
    putc('\n', stdout);
}
void eprintln(ZapString s) {
    eprint(s);
    putc('\n', stderr);
}

typedef struct ZprArgs {
    int count;
    const char* const* arr;
} ZprArgs;

static ZprArgs _args;

usize getArgCount() {
    return _args.count;
}

ZapString getArg(usize index) {
    assert(index < _args.count);
    return (ZapString) {
        .ptr = _args.arr[index],
        .len = strlen(_args.arr[index]),
    };
}

extern int run();
int main(int argc, const char* const* argv) {
    _args = (ZprArgs) { .count = argc, .arr = argv };
    return run();
}
