function cluck_set_light_direction(index, color, dx, dy, dz) {
    var position = index * __cluck_light_data_size;
    var dist = -max(0.001, point_distance_3d(0, 0, 0, dx, dy, dz));
    global.__cluck_light_data[position +  0] = dx / dist;
    global.__cluck_light_data[position +  1] = dy / dist;
    global.__cluck_light_data[position +  2] = dz / dist;
    global.__cluck_light_data[position +  3] = CLUCK_LIGHT_DIRECTIONAL;
    // 4 unused
    // 5 unused
    // 6 unused
    // 7 unused
    global.__cluck_light_data[position +  8] = (color & 0x0000ff) / 0xff;
    global.__cluck_light_data[position +  9] = ((color & 0x00ff00) >> 8) / 0xff;
    global.__cluck_light_data[position + 10] = ((color & 0xff0000) >> 16) / 0xff;
    // 11 unused
}