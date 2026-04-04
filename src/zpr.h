#include <stdbool.h>

typedef int isize;

typedef unsigned long long ZapUInt64;

typedef struct ZapString {
    const char* ptr;
    isize len;
} ZapString;

isize slen(ZapString s);
char sindex(ZapString s, isize idx);
ZapString sslice(ZapString s, isize start, isize end);
bool streql(ZapString a, ZapString b);

void print(ZapString s);
void eprint(ZapString s);

void println(ZapString s);
void eprintln(ZapString s);

void printInt(int n);

bool isError();

ZapString readFile(ZapString path);
void freeFileContent(ZapString content);

isize getArgCount();
ZapString getArg(isize index);
