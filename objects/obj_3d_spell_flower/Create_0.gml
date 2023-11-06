event_inherited();

self.target = undefined;

self.state = new SnowState("idle")
	.add("idle", {
		update: function() {
		}
	})

self.OnSpellHit = function(spell) {
    if (spell.object_index != self.spell_response) return;
    
};