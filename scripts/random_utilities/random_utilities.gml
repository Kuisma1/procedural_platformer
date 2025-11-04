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

function hash_to_random01(_h) {
    // Convert signed int to unsigned (wrap negatives into positive space)
    var _uh = _h & $FFFFFFFF; // mask to 32 bits
    // Normalize to [0,1)
    return _uh / 4294967296.0; // 2^32
}

function perlin2D(_x, _y, _scale, _seed) {
	_x = (_x+0.5)/_scale;
	_y = (_y+0.5)/_scale;
	
	var _i1 = floor(_x);
	var _j1 = floor(_y);
	var _i2 = _i1 + 1;
	var _j2 = _j1 + 1;
	
	var _fx = _x - _i1;
	var _fy = _y - _j1;
	
	var _g11 = random_gradient(_i1, _j1, _seed);
	var _g21 = random_gradient(_i2, _j1, _seed);
	var _g12 = random_gradient(_i1, _j2, _seed);
	var _g22 = random_gradient(_i2, _j2, _seed);
	
	var _d11 = dot_product(_g11[0], _g11[1], _fx, _fy);
	var _d21 = dot_product(_g21[0], _g21[1], _fx - 1, _fy);
	var _d12 = dot_product(_g12[0], _g12[1], _fx, _fy - 1);
	var _d22 = dot_product(_g22[0], _g22[1], _fx - 1, _fy - 1);
	
	var _u = fade(_fx);
	var _v = fade(_fy);

	var _nx1 = lerp(_d11, _d21, _u);
	var _nx2 = lerp(_d12, _d22, _u);
	var _value = lerp(_nx1, _nx2, _v);
	
	return 0.5*(_value+1);
}

function fade(_t) {
	return _t*_t*_t*(_t*(_t*6-15)+10)
}

function random_gradient(_i, _j, _seed) {
	//var _combined = (_i * 73856093) ^ (_j * 19349663) ^ _seed;
	var _combined = hash3(_i, _j, _seed);
	var _angle = 2*pi*hash_to_random01(_combined);
	var _gradient = [cos(_angle), sin(_angle)];
	return _gradient;
}