// draw the base
var position_mat = matrix_build(self.x, self.y, self.z, 0, 0, 0, 1, 1, 1);
var transform_mat = matrix_multiply(self.rotation_mat, position_mat);
matrix_set(matrix_world, transform_mat);
self.mesh.Render(0);

// draw the lid
var lid_position = array_search_with_name(self.mesh.collision_shapes, "#Top").position;
var lid_rotation_matrix = matrix_build(0, 0, 0, -self.chest_angle, 0, 0, 1, 1, 1);
var lid_position_matrix = matrix_multiply(lid_rotation_matrix, matrix_build(lid_position.x, lid_position.y, lid_position.z, 0, 0, 0, 1, 1, 1));
var position_mat = matrix_multiply(lid_position_matrix, matrix_build(self.x, self.y, self.z, 0, 0, 0, 1, 1, 1));
var transform_mat = matrix_multiply(self.rotation_mat, position_mat);
matrix_set(matrix_world, transform_mat);
self.mesh.Render(1);

if (self.can_be_unlocked && self.state.get_current_state() == "closed") {
    // draw the lock
    var lock_position = array_search_with_name(self.mesh.collision_shapes, "#Lock").position;
    var lock_position_matrix = matrix_build(lock_position.x, lock_position.y, lock_position.z, 0, 0, 0, 1, 1, 1);
    var position_mat = matrix_multiply(lock_position_matrix, matrix_build(self.x, self.y, self.z, 0, 0, 0, 1, 1, 1));
    var transform_mat = matrix_multiply(self.rotation_mat, position_mat);
    matrix_set(matrix_world, transform_mat);
    self.mesh.Render(2);
}

matrix_set(matrix_world, matrix_build_identity());