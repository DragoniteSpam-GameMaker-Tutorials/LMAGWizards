event_inherited();

self.SetMesh(obj_game.meshes.seesaw_pivot);
self.UpdateCollisionPositions();

self.mesh_seesaw = obj_game.meshes.seesaw_seesaw;
self.mesh_block_left = obj_game.meshes.seesaw_block_left;
self.mesh_block_right = obj_game.meshes.seesaw_block_right;

var shape_seesaw = col_shape_from_penguin(self.mesh_seesaw.collision_shapes[0], ECollisionMasks.DEFAULT, ECollisionMasks.DEFAULT);
self.cobject_seesaw = new ColObject(shape_seesaw.shape, self, shape_seesaw.shape_mask, shape_seesaw.shape_group);

var shape_block_left = col_shape_from_penguin(self.mesh_block_left.collision_shapes[0], ECollisionMasks.DEFAULT, ECollisionMasks.DEFAULT);
self.cobject_block_left = new ColObject(shape_seesaw.shape, self, shape_seesaw.shape_mask, shape_seesaw.shape_group);

var shape_block_right = col_shape_from_penguin(self.mesh_block_right.collision_shapes[0], ECollisionMasks.DEFAULT, ECollisionMasks.DEFAULT);
self.cobject_block_right = new ColObject(shape_seesaw.shape, self, shape_seesaw.shape_mask, shape_seesaw.shape_group);

self.seesaw_angle = 0;

self.matrix_base = undefined;
self.matrix_seesaw = undefined;
self.matrix_block_left = undefined;
self.matrix_block_right = undefined;

self.CalculateAllPositions = function() {
    if (keyboard_check(vk_pageup)) {
        self.state.change("tilt_left");
    }

    if (keyboard_check(vk_pagedown)) {
        self.state.change("tilt_right");
    }
    
    var base_position_matrix = matrix_build(self.x, self.y, self.z, 0, 0, 0, 1, 1, 1);
    self.matrix_base = matrix_multiply(self.rotation_mat, base_position_matrix);
    
    // draw the seesaw
    var seesaw_position = array_search_with_name(self.mesh.collision_shapes, "#AnchorSeesaw").position;
    var seesaw_rotation_matrix = matrix_build(0, 0, 0, 0, 0, self.seesaw_angle, 1, 1, 1);
    var seesaw_transform_matrix = matrix_multiply(seesaw_rotation_matrix, matrix_build(seesaw_position.x, seesaw_position.y, seesaw_position.z, 0, 0, 0, 1, 1, 1));
    var seesaw_final_position_matrix = matrix_multiply(seesaw_transform_matrix, base_position_matrix);
    self.matrix_seesaw = matrix_multiply(self.rotation_mat, seesaw_final_position_matrix);
    
    var block_left_position = array_search_with_name(self.mesh_seesaw.collision_shapes, "#AnchorLeft").position;
    var block_left_position_object = matrix_transform_vertex(seesaw_transform_matrix, block_left_position.x, block_left_position.y, block_left_position.z);
    var block_left_transform_matrix = matrix_build(block_left_position_object[0], block_left_position_object[1], block_left_position_object[2], 0, 0, 0, 1, 1, 1);
    var block_left_final_position_matrix = matrix_multiply(base_position_matrix, block_left_transform_matrix);
    self.matrix_block_left = matrix_multiply(self.rotation_mat, block_left_final_position_matrix);
    
    var block_right_position = array_search_with_name(self.mesh_seesaw.collision_shapes, "#AnchorRight").position;
    var block_right_position_object = matrix_transform_vertex(seesaw_transform_matrix, block_right_position.x, block_right_position.y, block_right_position.z);
    var block_right_transform_matrix = matrix_build(block_right_position_object[0], block_right_position_object[1], block_right_position_object[2], 0, 0, 0, 1, 1, 1);
    var block_right_final_position_matrix = matrix_multiply(base_position_matrix, block_right_transform_matrix);
    self.matrix_block_right = matrix_multiply(self.rotation_mat, block_right_final_position_matrix);
    
    col_object_update_position(self.cobject_seesaw, self.matrix_seesaw);
    col_object_update_position(self.cobject_block_left, self.matrix_block_left);
    col_object_update_position(self.cobject_block_right, self.matrix_block_right);
};

self.state = new SnowState("balanced")
	.add("balanced", {
		update: function() {
            static turn_rate = 120;
            self.seesaw_angle = approach(self.seesaw_angle, 0, turn_rate * DT);
            self.CalculateAllPositions();
        }
	})
	.add("tilt_left", {
		update: function() {
            static turn_rate = 120;
            self.seesaw_angle = approach(self.seesaw_angle, -15, turn_rate * DT);
            self.CalculateAllPositions();
        }
	})
	.add("tilt_right", {
		update: function() {
            static turn_rate = 120;
            self.seesaw_angle = approach(self.seesaw_angle, 15, turn_rate * DT);
            self.CalculateAllPositions();
        }
	});