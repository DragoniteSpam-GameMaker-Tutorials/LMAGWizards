event_inherited();

self.target = undefined;

self.state = new SnowState("idle")
	.add("idle", {
		onhit: function() {
			self.state.change("active");
		}
	})
	.add("active", {
		enter: function() {
			self.SetMesh(obj_game.meshes.flower_open);
			self.UpdateCollisionPositions();
		},
		update: function() {
			
		}
	});

self.OnSpellHit = function(spell) {
    if (spell.object_index != self.spell_response) return;
    
	self.state.onhit();
};