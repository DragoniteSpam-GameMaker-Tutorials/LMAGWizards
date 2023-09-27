event_inherited();

self.button_offset = 0;

self.OnActivation = function() {
    
};

self.state = new SnowState("primed", false)
	.add("primed", {
        onspell: function() {
            self.state.change("activating");
        }
	})
	.add("activating", {
        update: function() {
            static target_offset = -6;
            static movement_speed = 12;
            self.button_offset = approach(self.button_offset, target_offset, movement_speed * DT);
            if (self.button_offset == target_offset) {
                self.state.change("active");
            }
        }
	})
	.add("active", {
        enter: function() {
            self.OnActivation();
            if (self.infinite_use) {
                self.state.change("deactivating");
            }
        }
	})
	.add("deactivating", {
        update: function() {
            static target_offset = 0;
            static movement_speed = 4;
            self.button_offset = approach(self.button_offset, target_offset, movement_speed * DT);
            if (self.button_offset == target_offset) {
                self.state.change("primed");
            }
        }
	});

self.OnSpellHit = function(spell) {
    if (spell.object_index != self.spell_response) return;
    
    self.state.onspell();
};