function hash2(_a, _b) {
    var _h = _a * 0x85ebca6b;
    _h ^= _b + 0xc2b2ae35;
    _h ^= _h >> 16;
    _h *= 0x27d4eb2d;
    _h ^= _h >> 15;
    return _h;
}

function hash3(_a, _b, _c) {
    var _h = _c;
    _h ^= _a * 374761393;
    _h ^= _b * 668265263;
    _h = (_h ^ (_h >> 13)) * 1274126177;
    return _h;
}

/// @function hash_to_random01(h)
/// @desc Maps a signed 32-bit integer hash to a float in [0,1).
/// @param _h The signed 32-bit integer hash.
function hash_to_random01(_h) {
    // Convert signed int to unsigned (wrap negatives into positive space)
    var _uh = _h & $FFFFFFFF; // mask to 32 bits
    // Normalize to [0,1)
    return _uh / 4294967296.0; // 2^32
}

function 