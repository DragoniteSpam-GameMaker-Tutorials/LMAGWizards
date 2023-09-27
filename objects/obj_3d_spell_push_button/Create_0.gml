event_inherited();

self.button_offset = 0;

self.OnActivation = function() {
    
};

self.OnDeactivation = function() {
    
};

self.state = new SnowState("primed", false)
	.add("primed", {
        enter: function() {
            self.OnDeactivation();
        },
        onspell: function() {
            self.state.change("activating");
        }
	})
	.add("activating", {
        update: function() {
            static target_offset = -6;
            static movement_speed = 8;
            self.button_offset = approach(self.button_offset, target_offset, movement_speed * DT);
            if (self.button_offset == target_offset) {
                self.state.change("active");
            }
        }
	})
	.add("active", {
        enter: function() {
            self.OnActivation();
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