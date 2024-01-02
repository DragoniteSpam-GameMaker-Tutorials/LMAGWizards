// draw the base
var position_mat = matrix_build(self.x, self.y, self.z, 0, 0, 0, 1, 1, 1);
var transform_mat = matrix_multiply(self.rotation_mat, position_mat);
matrix_set(matrix_world, transform_mat);
self.mesh.Render(0);

if (self.state.get_current_state() == "unpressed") {
    self.mesh.Render(1);
}
matrix_set(matrix_world, matrix_build_identity());