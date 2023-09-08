event_inherited();

self.target = undefined;

self.state = new SnowState("idle")
	.add("idle", {
	})
	.add("moving", {
		update: function() {
			static velocity = 160;
			var updated_position = new Vector3(self.x, self.y, self.z).Approach(self.target, velocity * DT);
			var old_x = self.x;
			var old_y = self.y;
			var old_z = self.z;
			self.x = updated_position.x;
			self.y = updated_position.y;
			self.z = updated_position.z;
			self.UpdateCollisionPositions();
			if (obj_game.collision.CheckObject(self.cobjects[0])) {
				self.x = old_x;
				self.y = old_y;
				self.z = old_z;
				self.UpdateCollisionPositions();
			}
			
			if (point_distance_3d(self.x, self.y, self.z, self.target.x, self.target.y, self.target.z) == 0) {
				self.state.change("idle");
			}
		}
	});

self.OnSpellHit = function(spell) {
    if (spell.object_index != self.spell_response) return;
    
	var dir = point_direction(0, 0, spell.velocity.x, spell.velocity.z);
	var dist = 32;
    self.target = new Vector3(self.x + dist * dcos(dir), self.y, self.z - dist * dsin(dir));
	self.state.change("moving");
};