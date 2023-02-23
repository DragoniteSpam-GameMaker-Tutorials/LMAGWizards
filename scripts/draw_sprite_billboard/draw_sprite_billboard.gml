function draw_sprite_billboard(sprite, subimage, xx, yy, zz, shader = shd_gbuff_billboard) {
    shader_set(shader);
    
    gpu_set_tex_repeat(true);
    gpu_set_tex_filter(true);
    
    var t = current_time / 1000;
    
    var displacement_sampler = shader_get_sampler_index(shader, "samp_DisplacementMap");
    texture_set_stage(displacement_sampler, sprite_get_texture(spr_noise, 0));
    var time_uniform = shader_get_uniform(shader, "u_Time");
    shader_set_uniform_f(time_uniform, frac(t / 10), 0);
    
    matrix_set(matrix_world, matrix_build(xx, yy, zz, 0, 0, 0, 1, 1, 1));
    draw_sprite(sprite, subimage, 0, 0);
    matrix_set(matrix_world, matrix_build_identity());
    shader_reset();
    
    gpu_set_tex_repeat(false);
    gpu_set_tex_filter(false);
}