matrix_set(matrix_world, matrix_build(self.x, self.y, self.z, 0, 0, 0, 10, 10, 10));
vertex_submit(obj_game.debug_sphere, pr_trianglelist, -1);
matrix_set(matrix_world, matrix_build_identity());