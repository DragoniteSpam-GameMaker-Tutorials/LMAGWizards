matrix_set(matrix_world, self.matrix_base);
self.mesh.Render();

matrix_set(matrix_world, self.matrix_seesaw);
self.mesh_seesaw.Render();
matrix_set(matrix_world, self.matrix_block_left);
self.mesh_block_left.Render();
matrix_set(matrix_world, self.matrix_block_right);
self.mesh_block_right.Render();

matrix_set(matrix_world, matrix_build_identity());