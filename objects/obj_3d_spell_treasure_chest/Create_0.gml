event_inherited();

self.switch_angle = 0;

self.OnActivation = function() {
    
};

self.OnDeactivation = function() {
    
};

self.state = new SnowState("inactive", false)
	.add("inactive", {
        enter: function() {
            self.OnDeactivation();
        },
        onspell: function() {
            self.state.change("activating");
        }
	})
	.add("activating", {
        update: function() {
            static target_angle = 60;
            static movement_speed = 90;
            self.switch_angle = approach(self.switch_angle, target_angle, movement_speed * DT);
            if (self.switch_angle == target_angle) {
                self.state.change("active");
            }
        }
	})
	.add("active", {
        enter: function() {
            self.OnActivation();
        },
        onspell: function() {
            self.state.change("deactivating");
        }
	})
	.add("deactivating", {
        update: function() {
            static target_angle = 0;
            static movement_speed = 90;
            self.switch_angle = approach(self.switch_angle, target_angle, movement_speed * DT);
            if (self.switch_angle == target_angle) {
                self.state.change("inactive");
            }
        }
	});

self.OnSpellHit = function(spell) {
    if (spell.object_index != self.spell_response) return;
    
    self.state.onspell();
};