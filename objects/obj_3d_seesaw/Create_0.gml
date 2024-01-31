event_inherited();

self.mesh_pivot = obj_game.meshes.seesaw_pivot;
self.mesh_seesaw = obj_game.meshes.seesaw_seesaw;
self.mesh_block_left = obj_game.meshes.seesaw_block_left;
self.mesh_block_right = obj_game.meshes.seesaw_block_right;

self.seesaw_angle = 0;

self.state = new SnowState("balanced")
	.add("balanced", {
		update: function() {
            static turn_rate = 120;
            self.seesaw_angle = approach(self.seesaw_angle, 0, 120 * DT);
        }
	})
	.add("tilt_left", {
		update: function() {
            static turn_rate = 120;
            self.seesaw_angle = approach(self.seesaw_angle, -15, 120 * DT);
        }
	})
	.add("tilt_right", {
		update: function() {
            static turn_rate = 120;
            self.seesaw_angle = approach(self.seesaw_angle, 15, 120 * DT);
        }
	});