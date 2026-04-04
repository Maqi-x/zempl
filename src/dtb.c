#include "zpr.h"

#include <stdlib.h>
#include <string.h>

// dtb - dynamic text buffer
char* dtbData;
isize dtbSize;
isize dtbCap;

bool dtbResize(isize newCap) {
    if (newCap == 0) {
        if (dtbData != NULL) free(dtbData);
        dtbData = NULL;
        dtbCap = 0;
        dtbSize = 0;
        return true;
    }

    char* newBuf = malloc(newCap);
    if (newBuf == NULL) {
        return false;
    }

    if (dtbData != NULL) {
        isize toCopy = dtbSize < newCap ? dtbSize : newCap;
        memcpy(newBuf, dtbData, toCopy);
        free(dtbData);
    }
    dtbData = newBuf;
    dtbCap = newCap;
    return true;
}

bool dtbInit(isize initialCap) {
    dtbData = NULL;
    dtbSize = 0;
    dtbCap = 0;
    if (initialCap > 0) {
        return dtbResize(initialCap);
    }
    return true;
}

bool dtbPushString(ZapString s) {
    if (dtbSize + s.len > dtbCap) {
        isize newCap = dtbCap == 0 ? 16 : dtbCap * 2;
        while (newCap < dtbSize + s.len) newCap *= 2;
        if (!dtbResize(newCap)) return false;
    }
    memcpy(dtbData + dtbSize, s.ptr, s.len);
    dtbSize += s.len;
    return true;
}

bool dtbPushChar(char c) {
    if (dtbSize + 1 > dtbCap) {
        isize newCap = dtbCap == 0 ? 16 : dtbCap * 2;
        if (!dtbResize(newCap)) return false;
    }
    dtbData[dtbSize] = c;
    dtbSize++;
    return true;
}

ZapString dtbGetString() {
    ZapString s;
    s.ptr = dtbData;
    s.len = dtbSize;
    return s;
}

void dtbClear() {
    dtbSize = 0;
}

void dtbFree() {
    if (dtbData != NULL) {
        free(dtbData);
        dtbData = NULL;
    }
    dtbSize = 0;
    dtbCap = 0;
}
