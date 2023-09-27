event_inherited();

self.switch_angle = 0;

self.state = new SnowState("inactive")
	.add("inactive", {
	})
	.add("activating", {
	})
	.add("active", {
	})
	.add("deactivating", {
	});

self.OnSpellHit = function(spell) {
    if (spell.object_index != self.spell_response) return;
    
};