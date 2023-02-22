function cluck_apply(shader, view_mat) {
    static warnings = { };
    if (!shader_is_compiled(shader)) {
        if (warnings[$ shader]) {
            show_debug_message("Warning: trying to set a shader which is not compiled - " + shader_get_name(shader));
            warnings[$ shader] = true;
        }
        return;
    }
    var fog_color = global.__cluck_fog_color;
    var ambient_color = global.__cluck_light_ambient;
    
    static light_active_data_primary = array_create(CLUCK_MAX_LIGHTS * 4);
    static light_active_data_secondary = array_create(CLUCK_MAX_LIGHTS * 4);
    static light_active_data_tertiary = array_create(CLUCK_MAX_LIGHTS * 4);
    var light_count = 0;
    for (var i = 0, n = array_length(global.__cluck_light_data); i < n; i += __cluck_light_data_size) {
        if (global.__cluck_light_data[i + 3] != 0) {
            var index = light_count * 4;
            light_count++;
            
            array_copy(light_active_data_primary,    index, global.__cluck_light_data, i + 0, 4);
            array_copy(light_active_data_secondary,  index, global.__cluck_light_data, i + 4, 4);
            array_copy(light_active_data_tertiary, index, global.__cluck_light_data, i + 8, 4);
            
            // transform everything from world space to view space
            switch (global.__cluck_light_data[i + 3] % 16) {
                case CLUCK_LIGHT_DIRECTIONAL:
                    var transformed_direction = matrix_transform_vertex(view_mat, light_active_data_primary[index + 0], light_active_data_primary[index + 1], light_active_data_primary[index + 2], 0);
                    var mag = point_distance_3d(0, 0, 0, transformed_direction[0], transformed_direction[1], transformed_direction[2]);
                    transformed_direction[0] /= mag;
                    transformed_direction[1] /= mag;
                    transformed_direction[2] /= mag;
                    
                    light_active_data_primary[index + 0] = transformed_direction[0];
                    light_active_data_primary[index + 1] = transformed_direction[1];
                    light_active_data_primary[index + 2] = transformed_direction[2];
                    break;
                case CLUCK_LIGHT_POINT:
                    var transformed_position = matrix_transform_vertex(view_mat, light_active_data_primary[index + 0], light_active_data_primary[index + 1], light_active_data_primary[index + 2], 1);
                    
                    light_active_data_primary[index + 0] = transformed_position[0];
                    light_active_data_primary[index + 1] = transformed_position[1];
                    light_active_data_primary[index + 2] = transformed_position[2];
                    break;
                case CLUCK_LIGHT_SPOT:
                    var transformed_position = matrix_transform_vertex(view_mat, light_active_data_primary[index + 0], light_active_data_primary[index + 1], light_active_data_primary[index + 2], 1);
                    
                    light_active_data_primary[index + 0] = transformed_position[0];
                    light_active_data_primary[index + 1] = transformed_position[1];
                    light_active_data_primary[index + 2] = transformed_position[2];
                    
                    var transformed_direction = matrix_transform_vertex(view_mat, light_active_data_secondary[index + 0], light_active_data_secondary[index + 1], light_active_data_secondary[index + 2], 0);
                    var mag = point_distance_3d(0, 0, 0, transformed_direction[0], transformed_direction[1], transformed_direction[2]);
                    transformed_direction[0] /= mag;
                    transformed_direction[1] /= mag;
                    transformed_direction[2] /= mag;
                    
                    light_active_data_secondary[index + 0] = transformed_direction[0];
                    light_active_data_secondary[index + 1] = transformed_direction[1];
                    light_active_data_secondary[index + 2] = transformed_direction[2];
                    break;
            }
        }
    }
    
    shader_set(shader);
    
    shader_set_uniform_i(shader_get_uniform(shader, "u_LightCount"), light_count);
    shader_set_uniform_f_array(shader_get_uniform(shader, "u_LightDataPrimary"), light_active_data_primary);
    shader_set_uniform_f_array(shader_get_uniform(shader, "u_LightDataSecondary"), light_active_data_secondary);
    shader_set_uniform_f_array(shader_get_uniform(shader, "u_LightDataTertiary"), light_active_data_tertiary);
    
    shader_set_uniform_f(shader_get_uniform(shader, "u_LightAmbientColor"), (ambient_color & 0x0000ff) / 0xff, ((ambient_color & 0x00ff00) >> 8) / 0xff, ((ambient_color & 0xff0000) >> 16) / 0xff);
    
    shader_set_uniform_f(shader_get_uniform(shader, "u_FogStrength"), global.__cluck_fog_enabled ? global.__cluck_fog_strength : 0);
    shader_set_uniform_f(shader_get_uniform(shader, "u_FogStart"), global.__cluck_fog_start);
    shader_set_uniform_f(shader_get_uniform(shader, "u_FogEnd"), global.__cluck_fog_end);
    shader_set_uniform_f(shader_get_uniform(shader, "u_FogColor"), (fog_color & 0x0000ff) / 0xff, ((fog_color & 0x00ff00) >> 8) / 0xff, ((fog_color & 0xff0000) >> 16) / 0xff);
}