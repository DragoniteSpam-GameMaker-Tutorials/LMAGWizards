function cluck_set_light_point(index, color, x, y, z, radius, radius_inner = 0) {
    var position = index * __cluck_light_data_size;
    global.__cluck_light_data[position +  0] = x;
    global.__cluck_light_data[position +  1] = y;
    global.__cluck_light_data[position +  2] = z;
    global.__cluck_light_data[position +  3] = CLUCK_LIGHT_POINT;
    // 4 unused
    // 5 unused
    global.__cluck_light_data[position +  6] = radius_inner;
    global.__cluck_light_data[position +  7] = radius;
    global.__cluck_light_data[position +  8] = (color & 0x0000ff) / 0xff;
    global.__cluck_light_data[position +  9] = ((color & 0x00ff00) >> 8) / 0xff;
    global.__cluck_light_data[position + 10] = ((color & 0xff0000) >> 16) / 0xff;
    // 11 unused
}