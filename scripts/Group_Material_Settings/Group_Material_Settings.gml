enum EMaterialTypes {
    NORMAL,
    UNLIT,
}

function material_set_material_type(type) {
    if (shader_current() == -1) return;
    
    switch (type) {
        case EMaterialTypes.NORMAL:
            shader_set_uniform_f(shader_get_uniform(shader_current(), "u_MaterialType"), 1);
            break;
        case EMaterialTypes.UNLIT:
            shader_set_uniform_f(shader_get_uniform(shader_current(), "u_MaterialType"), 0);
            break;
    }
}