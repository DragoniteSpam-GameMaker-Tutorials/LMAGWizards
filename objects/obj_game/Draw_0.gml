matrix_set(matrix_world, matrix_build(200, 0, 200, 0, 0, 0, 1, 1, 1));
vertex_submit(self.block, pr_trianglelist, sprite_get_texture(tex_block_singular, 0));
matrix_set(matrix_world, matrix_build_identity());