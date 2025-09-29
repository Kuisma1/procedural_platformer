function hash(_x, _y, _seed) {
    var _h = _seed;
    _h ^= _x * 374761393;
    _h ^= _y * 668265263;
    _h = (_h ^ (_h >> 13)) * 1274126177;
    return _h; // ensure non-negative
}

function hash_n() {
    var h = 2166136261; // FNV offset basis (example)
    for (var i = 0; i < argument_count; i++) {
        h = h ^ argument[i];
        h = h * 16777619; // FNV prime
    }
    return h;
}