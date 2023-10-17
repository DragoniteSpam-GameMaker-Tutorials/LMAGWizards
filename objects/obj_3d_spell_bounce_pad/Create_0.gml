event_inherited();

self.state = new SnowState("inactive")
	.add("inactive", {
        onspell: function() {
            self.state.change("activating");
        }
	})
    .add("activating", {
        enter: function() {
            self.state.change("active");
        }
    })
	.add("active", {
        enter: function() {
            static bounce_time = 15;
            self.event_timer = bounce_time;
        },
		update: function() {
			self.event_timer -= DT;
            if (self.event_timer <= 0) {
                self.state.change("deactivating");
            }
		}
	})
    .add("deactivating" {
        enter: function() {
            self.state.change("inactive");
        }
    });

self.OnSpellHit = function(spell) {
    if (spell.object_index != self.spell_response) return;
    
    //self.state.onspell();
};