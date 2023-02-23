function draw_sprite_billboard(sprite, subimage, xx, yy, zz) {
    shader_set(shd_gbuff_billboard);
    matrix_set(matrix_world, matrix_build(xx, yy, zz, 0, 0, 0, 1, 1, 1));
    draw_sprite(sprite, subimage, 0, 0);
    matrix_set(matrix_world, matrix_build_identity());
    shader_reset();
}