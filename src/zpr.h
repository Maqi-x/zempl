#include <stdbool.h>

typedef int isize;

typedef struct ZapString {
    const char* ptr;
    isize len;
} ZapString;

typedef struct ZapStringResult {
    ZapString string;
    bool ok;
} ZapStringResult;

bool streql(ZapString a, ZapString b);

void print(ZapString s);
void eprint(ZapString s);

void println(ZapString s);
void eprintln(ZapString s);

void printInt(int n);

ZapStringResult readFile(ZapString path);
void freeFileContent(ZapString content);

isize getArgCount();
ZapString getArg(isize index);
