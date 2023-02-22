function cluck_set_light_disable(index) {
    var position = index * __cluck_light_data_size;
    global.__cluck_light_data[position +  0] = 0;
    global.__cluck_light_data[position +  1] = 0;
    global.__cluck_light_data[position +  2] = 0;
    global.__cluck_light_data[position +  3] = CLUCK_LIGHT_NONE;
    global.__cluck_light_data[position +  4] = 0;
    global.__cluck_light_data[position +  5] = 0;
    global.__cluck_light_data[position +  6] = 0;
    global.__cluck_light_data[position +  7] = 0;
    global.__cluck_light_data[position +  8] = 0;
    global.__cluck_light_data[position +  9] = 0;
    global.__cluck_light_data[position + 10] = 0;
    global.__cluck_light_data[position + 11] = 0;
}