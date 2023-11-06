event_inherited();

self.target = undefined;

self.state = new SnowState("inactive")
	.add("inactive", {
		enter: function() {
			self.SetMesh(obj_game.meshes.flower);
			self.UpdateCollisionPositions();
		},
		onhit: function() {
			self.state.change("active");
		}
	})
	.add("active", {
		enter: function() {
			self.SetMesh(obj_game.meshes.flower_open);
			self.UpdateCollisionPositions();
			
			static unbloom_duration = 30;	// seconds
			self.unbloom_timer = unbloom_duration;
		},
		update: function() {
			self.unbloom_timer -= DT;
			if (self.unbloom_timer <= 0) {
				self.state.change("inactive");
			}
		}
	});

self.OnSpellHit = function(spell) {
    if (spell.object_index != self.spell_response) return;
    
	self.state.onhit();
};