event_inherited();

self.target = undefined;

self.state = new SnowState("inactive")
	.add("inactive", {
		enter: function() {
			self.SetMesh(obj_game.meshes.hourglass);
			self.UpdateCollisionPositions();
		},
		onhit: function() {
			self.state.change("active");
		}
	})
	.add("active", {
		enter: function() {
			self.SetMesh(obj_game.meshes.hourglass_active);
			self.UpdateCollisionPositions();
			obj_game.ActivateTimer(self);
			
			static time_duration = 10;	// seconds
			self.time_timer = time_duration;
		},
		leave: function() {
			obj_game.DeactivateTimer(self);
		},
		update: function() {
			self.time_timer -= DT;
			if (self.time_timer <= 0) {
				self.state.change("inactive");
			}
		}
	});

self.OnSpellHit = function(spell) {
    if (spell.object_index != self.spell_response) return;
    
	self.state.onhit();
};