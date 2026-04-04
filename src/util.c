#include "zpr.h"

ZapUInt64 hashString(ZapString s) {
    const ZapUInt64 p = 31;
    const ZapUInt64 m = 1000000009;
    ZapUInt64 hash = 0;

    for (int i = 0; i < s.len; ++i) {
        hash = (hash * p + (unsigned char)s.ptr[i]) % m;
    }

    return hash;
}

