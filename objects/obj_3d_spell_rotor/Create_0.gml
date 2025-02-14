event_inherited();

self.rotor_direction = self.target_direction;

self.state = new SnowState("still", false)
	.add("still", {
        enter: function() {
            self.spell_response = obj_spell_push;
        },
        leave: function() {
            self.spell_response = undefined;
        },
        onspell: function(hit_info) {
            var vector_to_hit = hit_info.point.Sub(hit_info.shape.position);
            var direction_to_hit = point_direction(0, 0, vector_to_hit.x, vector_to_hit.z);
            var vector_to_rotor = hit_info.shape.position.Sub(new Vector3(self.x, self.y, self.z));
            var direction_to_rotor = point_direction(0, 0, vector_to_rotor.x, vector_to_rotor.z);
            
            if (angle_difference(direction_to_hit, direction_to_rotor) > 0) {
                self.target_direction = self.rotor_direction + 90;
            } else {
                self.target_direction = self.rotor_direction - 90;
            }
            self.state.change("turning");
        }
	})
	.add("turning", {
        update: function() {
            self.rotor_direction = approach(self.rotor_direction, self.target_direction, 1);
            
            self.rotation_mat = matrix_build(0, 0, 0, 0, self.rotor_direction, 0, 1, 1, 1);
            self.UpdateCollisionPositions();
            
            if (self.rotor_direction == self.target_direction) {
                self.state.change("still");
            }
        }
	});

self.OnSpellHit = function(spell, hit_info) {
    if (spell.object_index != self.spell_response) return;
    
    self.state.onspell(hit_info);
};