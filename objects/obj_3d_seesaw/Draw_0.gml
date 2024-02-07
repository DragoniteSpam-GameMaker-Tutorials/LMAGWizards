if (keyboard_check(vk_f1)) {
    col_object_debug_draw(self.cobjects[0], self.matrix_base);
    col_object_debug_draw(self.cobject_seesaw, self.matrix_seesaw);
    col_object_debug_draw(self.cobject_block_left, self.matrix_block_left);
    col_object_debug_draw(self.cobject_block_right, self.matrix_block_right);
} else {
    matrix_set(matrix_world, self.matrix_base);
    self.mesh.Render();
    matrix_set(matrix_world, self.matrix_seesaw);
    self.mesh_seesaw.Render();
    matrix_set(matrix_world, self.matrix_block_left);
    self.mesh_block_left.Render();
    matrix_set(matrix_world, self.matrix_block_right);
    self.mesh_block_right.Render();
}

matrix_set(matrix_world, matrix_build_identity());