#include "zpr.h"

#include <stddef.h>
#include <assert.h>
#include <string.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

bool errorFlag;
bool isError() {
    return errorFlag;
}
void setError(bool v) {
    errorFlag = v;
}

isize slen(ZapString s) {
    return s.len;
}
char sindex(ZapString s, isize idx) {
    return s.ptr[idx];
}
ZapString sslice(ZapString s, isize start, isize end) {
    if (start < 0) start = 0;
    if (end > s.len) end = s.len;
    if (start > end) return (ZapString) { .ptr = NULL, .len = 0 };
    return (ZapString) {
        .ptr = s.ptr + start,
        .len = end - start,
    };
}
bool streql(ZapString a, ZapString b) {
    if (a.len != b.len) return false;
    if (a.ptr == b.ptr) return true;
    return memcmp(a.ptr, b.ptr, b.len) == 0;
}

void print(ZapString s) {
    fwrite(s.ptr, s.len, 1, stdout);
}
void eprint(ZapString s) {
    fwrite(s.ptr, s.len, 1, stderr);
}

ZapString readFile(ZapString path) {
    errorFlag = false;

    char* cpath = malloc(path.len + 1);
    if (!cpath) {
        errorFlag = true;
        return (ZapString) { 0 };
    }
    memcpy(cpath, path.ptr, (size_t)path.len);
    cpath[path.len] = '\0';

    FILE* f = fopen(cpath, "rb");
    free(cpath);
    if (!f) {
        errorFlag = true;
        return (ZapString) { 0 };
    }

    fseek(f, 0, SEEK_END);
    long size = ftell(f);
    fseek(f, 0, SEEK_SET);

    char* buf = malloc((size_t)size);
    if (!buf) {
        fclose(f);
        errorFlag = true;
        return (ZapString) { 0 };
    }

    size_t read = fread(buf, 1, (size_t)size, f);
    fclose(f);

    if (read != (size_t)size) {
        free(buf);
        errorFlag = true;
        return (ZapString) { 0 };
    }

    return (ZapString) { .ptr = buf, .len = (isize)size };
}

ZapString readFromStdin() {
    errorFlag = false;

    isize cap = 1024;
    isize len = 0;
    char* buf = malloc((size_t)cap);
    if (!buf) {
        errorFlag = true;
        return (ZapString) { 0 };
    }

    int c;
    while ((c = getchar()) != EOF) {
        if (len >= cap) {
            cap *= 2;
            char* next = realloc(buf, (size_t)cap);
            if (!next) {
                free(buf);
                errorFlag = true;
                return (ZapString) { 0 };
            }
            buf = next;
        }
        buf[len++] = (char)c;
    }

    return (ZapString) { .ptr = buf, .len = len };
}

void freeFileContent(ZapString content) {
    free((void*)content.ptr);
}

bool writeFile(ZapString path, ZapString content) {
    errorFlag = false;

    char* cpath = malloc(path.len + 1);
    if (!cpath) {
        errorFlag = true;
        return false;
    }
    memcpy(cpath, path.ptr, (size_t)path.len);
    cpath[path.len] = '\0';

    FILE* f = fopen(cpath, "wb");
    free(cpath);
    if (!f) {
        errorFlag = true;
        return false;
    }

    size_t written = fwrite(content.ptr, 1, (size_t)content.len, f);
    fclose(f);

    if (written != (size_t)content.len) {
        errorFlag = true;
        return false;
    }

    return true;
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

extern int zap$src$mai$run();
int main(int argc, const char* const* argv) {
    _args = (ZprArgs) { .count = argc, .arr = argv };
    return zap$src$mai$run();
}
