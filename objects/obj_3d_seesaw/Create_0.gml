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

self.state = new SnowState("balanced")
	.add("balanced", {
		update: function() {
            static turn_rate = 120;
            self.seesaw_angle = approach(self.seesaw_angle, 0, turn_rate * DT);
        }
	})
	.add("tilt_left", {
		update: function() {
            static turn_rate = 120;
            self.seesaw_angle = approach(self.seesaw_angle, -15, turn_rate * DT);
        }
	})
	.add("tilt_right", {
		update: function() {
            static turn_rate = 120;
            self.seesaw_angle = approach(self.seesaw_angle, 15, turn_rate * DT);
        }
	});