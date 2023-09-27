event_inherited();

self.switch_angle = 0;

self.state = new SnowState("inactive")
	.add("inactive", {
        onspell: function() {
            self.state.change("activating");
        }
	})
	.add("activating", {
        update: function() {
            self.switch_angle = approach(self.switch_angle, 60, 60 * DT);
            if (self.switch_angle == 60) {
                self.state.change("active");
            }
        }
	})
	.add("active", {
        onspell: function() {
            self.state.change("deactivating");
        }
	})
	.add("deactivating", {
        update: function() {
            self.switch_angle = approach(self.switch_angle, 0, 60 * DT);
            if (self.switch_angle == 0) {
                self.state.change("inactive");
            }
        }
	});

self.OnSpellHit = function(spell) {
    if (spell.object_index != self.spell_response) return;
    
    self.state.onspell();
};