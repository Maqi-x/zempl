#include <stdbool.h>

typedef int isize;

typedef struct ZapString {
    const char* ptr;
    isize len;
} ZapString;

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
