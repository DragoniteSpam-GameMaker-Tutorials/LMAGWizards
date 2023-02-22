global.__cluck_light_ambient = c_white;
global.__cluck_light_data = array_create(CLUCK_MAX_LIGHTS * __cluck_light_data_size);

global.__cluck_fog_enabled = false;
global.__cluck_fog_strength = 1;
global.__cluck_fog_color = c_black;
global.__cluck_fog_start = 256;
global.__cluck_fog_end = 1024;

#macro CLUCK_MAX_LIGHTS 16
#macro CLUCK_LIGHT_NONE 0
#macro CLUCK_LIGHT_DIRECTIONAL 1
#macro CLUCK_LIGHT_POINT 2
#macro CLUCK_LIGHT_SPOT 3
#macro __cluck_light_data_size 12