function cluck_set_light_spot(index, color, x, y, z, dx, dy, dz, range, cutoff, cutoff_inner = 0) {
    var position = index * __cluck_light_data_size;
    var dist = -max(0.001, point_distance_3d(0, 0, 0, dx, dy, dz));
    global.__cluck_light_data[position +  0] = x;
    global.__cluck_light_data[position +  1] = y;
    global.__cluck_light_data[position +  2] = z;
    global.__cluck_light_data[position +  3] = CLUCK_LIGHT_SPOT | (floor(dcos(cutoff_inner) * 128) << 4);
    global.__cluck_light_data[position +  4] = dx / dist;
    global.__cluck_light_data[position +  5] = dy / dist;
    global.__cluck_light_data[position +  6] = dz / dist;
    global.__cluck_light_data[position +  7] = range;
    global.__cluck_light_data[position +  8] = (color & 0x0000ff) / 0xff;
    global.__cluck_light_data[position +  9] = ((color & 0x00ff00) >> 8) / 0xff;
    global.__cluck_light_data[position + 10] = ((color & 0xff0000) >> 16) / 0xff;
    global.__cluck_light_data[position + 11] = dcos(cutoff);
}