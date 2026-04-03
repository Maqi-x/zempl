#include "zpr.h"

#include <stddef.h>
#include <assert.h>
#include <string.h>
#include <stdio.h>
#include <stdbool.h>

bool streql(ZapString a, ZapString b) {
    if (a.len != b.len) return false;
    if (a.ptr == b.ptr) return true;
    return memcmp(a.ptr, b.ptr, b.len);
}

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

void printInt(int n) {
    printf("%d\n", n);
}

typedef struct ZprArgs {
    int count;
    const char* const* arr;
} ZprArgs;

static ZprArgs _args;

isize getArgCount() {
    return _args.count;
}

ZapString getArg(isize index) {
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
