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

void setError(bool v);
bool isError();

ZapString readFile(ZapString path);
ZapString readFromStdin();
void freeFileContent(ZapString content);
bool writeFile(ZapString path, ZapString content);

isize getArgCount();
ZapString getArg(isize index);

// dtb - dynamic text buffer
bool dtbInit(isize initialCap);
bool dtbPushString(ZapString s);
bool dtbPushChar(char c);
ZapString dtbGetString();
void dtbClear();
void dtbFree();
