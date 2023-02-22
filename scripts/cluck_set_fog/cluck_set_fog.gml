function cluck_set_fog(enabled, color, strength, start, finish) {
    global.__cluck_fog_enabled = enabled;
    global.__cluck_fog_strength = strength;
    global.__cluck_fog_color = color;
    global.__cluck_fog_start = start;
    global.__cluck_fog_end = finish;
}