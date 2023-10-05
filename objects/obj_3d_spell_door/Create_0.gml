event_inherited();

self.door_angle = 0;

self.state = new SnowState("closed", false)
	.add("closed", {
        enter: function() {
            if (!self.can_be_unlocked) {
                self.spell_response = obj_spell_unlock;
            }
        },
        leave: function() {
            self.spell_response = undefined;
        },
        onspell: function() {
            if (self.can_be_unlocked)
                self.state.change("opening");
        }
	})
	.add("opening", {
        update: function() {
            static target_angle = 90;
            static movement_speed = 90;
            var door_angle_start = self.door_angle;
            self.door_angle = approach(self.door_angle, target_angle, movement_speed * DT);
            var door_angle_diff = self.door_angle - door_angle_start;
            self.rotation_mat = matrix_multiply(self.rotation_mat, matrix_build(0, 0, 0, 0, door_angle_diff, 0, 1, 1, 1));
            self.UpdateCollisionPositions();
            if (self.door_angle == target_angle) {
                self.state.change("open");
            }
        }
	})
	.add("open", {
        onspell: function() {
            if (self.can_be_unlocked)
                self.state.change("closing");
        }
	})
	.add("closing", {
        update: function() {
            static target_angle = 0;
            static movement_speed = 90;
            var door_angle_start = self.door_angle;
            self.door_angle = approach(self.door_angle, target_angle, movement_speed * DT);
            var door_angle_diff = self.door_angle - door_angle_start;
            self.rotation_mat = matrix_multiply(self.rotation_mat, matrix_build(0, 0, 0, 0, door_angle_diff, 0, 1, 1, 1));
            self.UpdateCollisionPositions();
            if (self.door_angle == target_angle) {
                self.state.change("closed");
            }
        }
	});

self.OnSpellHit = function(spell) {
    if (spell.object_index != self.spell_response) return;
    
    self.state.onspell();
};