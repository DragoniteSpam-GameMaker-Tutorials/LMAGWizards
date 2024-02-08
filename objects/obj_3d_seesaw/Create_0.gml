event_inherited();

self.SetMesh(obj_game.meshes.seesaw_pivot);
self.UpdateCollisionPositions();

self.mesh_seesaw = obj_game.meshes.seesaw_seesaw;
self.mesh_block_left = obj_game.meshes.seesaw_block_left;
self.mesh_block_right = obj_game.meshes.seesaw_block_right;

var shape_seesaw = col_shape_from_penguin(self.mesh_seesaw.collision_shapes[0], ECollisionMasks.DEFAULT, ECollisionMasks.DEFAULT);
self.cobject_seesaw = new ColObject(shape_seesaw.shape, self, shape_seesaw.shape_mask, shape_seesaw.shape_group);

var shape_block_left = col_shape_from_penguin(self.mesh_block_left.collision_shapes[0], ECollisionMasks.DEFAULT, ECollisionMasks.DEFAULT);
self.cobject_block_left = new ColObject(shape_block_left.shape, self, shape_block_left.shape_mask, shape_block_left.shape_group);

var shape_block_right = col_shape_from_penguin(self.mesh_block_right.collision_shapes[0], ECollisionMasks.DEFAULT, ECollisionMasks.DEFAULT);
self.cobject_block_right = new ColObject(shape_block_right.shape, self, shape_block_right.shape_mask, shape_block_right.shape_group);

var shape_activation_left = col_shape_from_penguin(array_search_with_name(self.mesh_block_left.collision_shapes, "#Activation"));
self.cobject_activation_left = new ColObject(shape_activation_left.shape, self, shape_activation_left.shape_mask, shape_activation_left.shape_group);

var shape_activation_right = col_shape_from_penguin(array_search_with_name(self.mesh_block_right.collision_shapes, "#Activation"));
self.cobject_activation_right = new ColObject(shape_activation_right.shape, self, shape_activation_right.shape_mask, shape_activation_right.shape_group);

self.seesaw_angle = 0;

self.matrix_base = undefined;
self.matrix_seesaw = undefined;
self.matrix_block_left = undefined;
self.matrix_block_right = undefined;

self.CalculateAllPositions = function() {
    var on_left = obj_game.collision.CheckObject(self.cobject_activation_left);
    var on_right = obj_game.collision.CheckObject(self.cobject_activation_right);
    
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
    var block_left_previous_y = is_array(self.matrix_block_left) ? self.matrix_block_left[13] : 0;
    self.matrix_block_left = matrix_multiply(self.rotation_mat, block_left_final_position_matrix);
    var block_left_delta_y = self.matrix_block_left[13] - block_left_previous_y;
    
    var block_right_position = array_search_with_name(self.mesh_seesaw.collision_shapes, "#AnchorRight").position;
    var block_right_position_object = matrix_transform_vertex(seesaw_transform_matrix, block_right_position.x, block_right_position.y, block_right_position.z);
    var block_right_transform_matrix = matrix_build(block_right_position_object[0], block_right_position_object[1], block_right_position_object[2], 0, 0, 0, 1, 1, 1);
    var block_right_final_position_matrix = matrix_multiply(base_position_matrix, block_right_transform_matrix);
    var block_right_previous_y = is_array(self.matrix_block_right) ? self.matrix_block_right[13] : 0;
    self.matrix_block_right = matrix_multiply(self.rotation_mat, block_right_final_position_matrix);
    var block_right_delta_y = self.matrix_block_right[13] - block_right_previous_y;
    
    col_object_update_position(self.cobject_seesaw, self.matrix_seesaw);
    col_object_update_position(self.cobject_block_left, self.matrix_block_left);
    col_object_update_position(self.cobject_block_right, self.matrix_block_right);
    
    col_object_update_position(self.cobject_activation_left, self.matrix_block_left);
    col_object_update_position(self.cobject_activation_right, self.matrix_block_right);
    
    if (on_left) {
        on_left = on_left.reference;
        if (on_left.object_index != obj_npc && !object_is_ancestor(on_left.object_index, obj_npc)) {
            on_left.y += block_left_delta_y;
            on_left.UpdateCollisionPositions();
        } else {
            on_left.cobject.shape.position.y += block_left_delta_y;
            on_left.y += block_left_delta_y;
        }
    }
    
    if (on_right) {
        on_right = on_right.reference;
        if (on_right.object_index != obj_npc && !object_is_ancestor(on_right.object_index, obj_npc)) {
            on_right.y += block_right_delta_y;
            on_right.UpdateCollisionPositions();
        } else {
            on_right.cobject.shape.position.y += block_right_delta_y;
            on_right.y += block_right_delta_y;
        }
    }
};

self.HandleActivation = function() {
    var is_left = obj_game.collision.CheckObject(self.cobject_activation_left);
    var is_right = obj_game.collision.CheckObject(self.cobject_activation_right);
    
    if (is_left && !is_right) {
        self.state.change("tilt_left");
    } else if (is_right && !is_left) {
        self.state.change("tilt_right");
    } else if (is_left && is_right) {
        if (is_left.reference.seesaw_mass > is_right.reference.seesaw_mass) {
            self.state.change("tilt_left");
        } else if (is_left.reference.seesaw_mass < is_right.reference.seesaw_mass) {
            self.state.change("tilt_right");
        } else {
            self.state.change("balanced");
        }
    }
};

self.state = new SnowState("balanced")
	.add("balanced", {
		update: function() {
            static turn_rate = 120;
            self.seesaw_angle = approach(self.seesaw_angle, 0, turn_rate * DT);
            self.CalculateAllPositions();
            self.HandleActivation();
        }
	})
	.add("tilt_left", {
		update: function() {
            static turn_rate = 120;
            static target_angle = 15;
            self.seesaw_angle = approach(self.seesaw_angle, target_angle, turn_rate * DT);
            self.CalculateAllPositions();
            if (self.seesaw_angle == target_angle) {
                self.state.change("left");
            }
        }
	})
	.add("tilt_right", {
		update: function() {
            static turn_rate = 120;
            static target_angle = -15;
            self.seesaw_angle = approach(self.seesaw_angle, target_angle, turn_rate * DT);
            self.CalculateAllPositions();
            if (self.seesaw_angle == target_angle) {
                self.state.change("left");
            }
        }
	})
    .add("left", {
		update: function() {
            self.HandleActivation();
        }
    })
    .add("right", {
		update: function() {
            self.HandleActivation();
        }
    });