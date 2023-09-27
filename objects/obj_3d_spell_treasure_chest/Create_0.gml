event_inherited();

self.chest_angle = 0;

if (!self.can_be_unlocked) {
    self.spell_response = undefined;
}

self.ExpelContents = function() {
    
};

self.state = new SnowState("closed", false)
	.add("closed", {
        onspell: function() {
            if (self.can_be_unlocked)
                self.state.change("opening");
        }
	})
	.add("opening", {
        update: function() {
            static target_angle = 120;
            static movement_speed = 90;
            self.chest_angle = approach(self.chest_angle, target_angle, movement_speed * DT);
            if (self.chest_angle == target_angle) {
                self.state.change("open");
            }
        }
	})
	.add("open", {
        enter: function() {
            self.ExpelContents();
        }
	})
	.add("closing", {
        update: function() {
            static target_angle = 0;
            static movement_speed = 90;
            self.chest_angle = approach(self.chest_angle, target_angle, movement_speed * DT);
            if (self.chest_angle == target_angle) {
                self.state.change("closed");
            }
        }
	});

self.OnSpellHit = function(spell) {
    if (spell.object_index != self.spell_response) return;
    
    self.state.onspell();
};