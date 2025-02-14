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
        onspell: function() {
            self.target_direction = self.rotor_direction + 90;
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

self.OnSpellHit = function(spell) {
    if (spell.object_index != self.spell_response) return;
    
    self.state.onspell();
};