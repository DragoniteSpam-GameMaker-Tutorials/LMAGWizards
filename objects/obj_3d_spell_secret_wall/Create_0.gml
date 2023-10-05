event_inherited();

self.distance_to_go = 32;

self.state = new SnowState("closed", false)
	.add("closed", {
        onspell: function() {
            self.state.change("opening");
        }
	})
	.add("opening", {
        update: function() {
            static movement_speed = 90;
            var start = self.distance_to_go;
            self.distance_to_go = max(0, self.distance_to_go - movement_speed * DT);
            var moved = start - self.distance_to_go;
            self.y -= moved;
            self.UpdateCollisionPositions();
            
            if (self.distance_to_go == 0) {
                self.state.change("open");
            }
        }
	})
	.add("open", {
        
	});

self.OnSpellHit = function(spell) {
    if (spell.object_index != self.spell_response) return;
    
    self.state.onspell();
};