ext fun hashString(s: String) UInt64;
ext fun streql(a: String, b: String) Bool; 

const CAPACITY: Int = 256;

struct Entry {
    key: String,
    value: String,
    used: Bool,
}

global var hmData: [CAPACITY]Entry;

fun hmInit() {
    var i: Int = 0;
    while i < CAPACITY {
        hmData[i].used = false;
        i = i + 1;
    }
}

fun hmPut(key: String, value: String) Bool {
    var idx: UInt64 = hashString(key);

    var i: Int = 0;
    while i < CAPACITY {
        var probe: UInt64 = (idx + i) % CAPACITY;

        var isUsed: Bool = (hmData[probe].used);
        if !isUsed {
            hmData[probe].key = key;
            hmData[probe].value = value;
            hmData[probe].used = true;
            return true;
        }

        if streql(hmData[probe].key, key) {
            hmData[probe].value = value;
            return true;
        }

        i = i + 1;
    }

    return false; // table full
}

fun hmGet(key: String) String {
    var idx: UInt64 = hashString(key);

    var i: Int = 0;
    while i < CAPACITY {
        var probe: UInt64 = (idx + i) % CAPACITY;

        var isUsed: Bool = hmData[probe].used;
        if !isUsed {
            return "";
        }
        if streql(hmData[probe].key, key) {
            return hmData[probe].value;
        }

        i = i + 1;
    }

    return "";
}
