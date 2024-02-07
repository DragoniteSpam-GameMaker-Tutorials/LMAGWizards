function surface_validate(surface, w, h, format = surface_rgba8unorm) {
    if (surface_exists(surface)) {
        if (surface_get_width(surface) == w && surface_get_height(surface) == h) {
            return surface;
        }
        surface_free(surface);
    }
    
    return surface_create(w, h, format);
}

/// @param {array<struct>} array
/// @param {string} name
function array_search_with_name(array, name) {
    var index = array_find_index(array, method({ name }, function(shape) {
        return shape.name == self.name;
    }));
    
    if (index == -1) return undefined;
    
    return array[index];
}

function approach(source, dest, amount) {
    return (source < dest) ? min(source + amount, dest) : max(source - amount, dest);
}