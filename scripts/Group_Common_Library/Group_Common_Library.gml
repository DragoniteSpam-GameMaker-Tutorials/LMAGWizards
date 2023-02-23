function surface_validate(surface, w, h, format = surface_rgba8unorm) {
    if (surface_exists(surface)) {
        if (surface_get_width(surface) == w && surface_get_height(surface) == h) {
            return surface;
        }
        surface_free(surface);
    }
    
    return surface_create(w, h, format);
}