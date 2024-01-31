var base_position_matrix = matrix_build(self.x, self.y, self.z, 0, 0, 0, 1, 1, 1);
var base_transform_matrix = matrix_multiply(self.rotation_mat, base_position_matrix);
matrix_set(matrix_world, base_transform_matrix);
self.mesh_pivot.Render();

// draw the seesaw
var seesaw_position = array_search_with_name(self.mesh_pivot.collision_shapes, "#AnchorSeesaw").position;
var seesaw_rotation_matrix = matrix_build(0, 0, 0, 0, 0, self.seesaw_angle, 1, 1, 1);

if (keyboard_check(vk_pageup)) {
    self.state.change("tilt_left");
}

if (keyboard_check(vk_pagedown)) {
    self.state.change("tilt_right");
}

var seesaw_transform_matrix = matrix_multiply(seesaw_rotation_matrix, matrix_build(seesaw_position.x, seesaw_position.y, seesaw_position.z, 0, 0, 0, 1, 1, 1));

var seesaw_final_position_matrix = matrix_multiply(seesaw_transform_matrix, base_position_matrix);
var seesaw_final_transform_matrix = matrix_multiply(self.rotation_mat, seesaw_final_position_matrix);
matrix_set(matrix_world, seesaw_final_transform_matrix);
self.mesh_seesaw.Render();

// draw the left block
var block_left_position = array_search_with_name(self.mesh_seesaw.collision_shapes, "#AnchorLeft").position;
var block_left_position_object = matrix_transform_vertex(seesaw_transform_matrix, block_left_position.x, block_left_position.y, block_left_position.z);
var block_left_transform_matrix = matrix_build(block_left_position_object[0], block_left_position_object[1], block_left_position_object[2], 0, 0, 0, 1, 1, 1);

var block_left_final_position_matrix = matrix_multiply(base_position_matrix, block_left_transform_matrix);
var block_left_final_transform_matrix = matrix_multiply(self.rotation_mat, block_left_final_position_matrix);
matrix_set(matrix_world, block_left_final_transform_matrix);
self.mesh_block_left.Render();

// draw the right block
var block_right_position = array_search_with_name(self.mesh_seesaw.collision_shapes, "#AnchorRight").position;
var block_right_position_object = matrix_transform_vertex(seesaw_transform_matrix, block_right_position.x, block_right_position.y, block_right_position.z);
var block_right_transform_matrix = matrix_build(block_right_position_object[0], block_right_position_object[1], block_right_position_object[2], 0, 0, 0, 1, 1, 1);

var block_right_final_position_matrix = matrix_multiply(base_position_matrix, block_right_transform_matrix);
var block_right_final_transform_matrix = matrix_multiply(self.rotation_mat, block_right_final_position_matrix);
matrix_set(matrix_world, block_right_final_transform_matrix);
self.mesh_block_right.Render();

matrix_set(matrix_world, matrix_build_identity());