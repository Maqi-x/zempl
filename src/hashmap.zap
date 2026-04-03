const CAPACITY: Int = 256;

struct Entry {
    key: String,
    value: String,
    used: Bool,
}

global var hmData: [CAPACITY]Entry;

ext fun hashString(s: String) UInt64;
fun hash(key: String) UInt64 {
    return hashString(key);
}

fun hmInit() {
    var i: Int = 0;
    while i < CAPACITY {
        hmData[i].used = false;
        i = i + 1;
    }
}

//fun hmPut(HashMap* map, int key, int value) {
//    unsigned int idx = hash(key);
//
//    for (int i = 0; i < CAPACITY; i++) {
//        unsigned int probe = (idx + i) % CAPACITY;
//
//        if (!map->data[probe].used) {
//            map->data[probe].key = key;
//            map->data[probe].value = value;
//            map->data[probe].used = true;
//            return true;
//        }
//
//        if (map->data[probe].key == key) {
//            map->data[probe].value = value;
//            return true;
//        }
//    }
//
//    return false; // table full
//} 
//
//bool hashmap_get(HashMap* map, int key, int* out) {
//    unsigned int idx = hash(key);
//
//    for (int i = 0; i < CAPACITY; i++) {
//        unsigned int probe = (idx + i) % CAPACITY;
//
//        if (!map->data[probe].used) {
//            return false;
//        }
//
//        if (map->data[probe].key == key) {
//            *out = map->data[probe].value;
//            return true;
//        }
//    }
//
//    return false;
//}
