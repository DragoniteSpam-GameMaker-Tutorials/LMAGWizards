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
                self.state.change("idle");
			}
			
			if (point_distance_3d(self.x, self.y, self.z, self.target.x, self.target.y, self.target.z) == 0) {
				self.target = self.CalculateMovementTarget();
			}
		}
	});

self.OnSpellHit = function(spell) {
    if (spell.object_index != self.spell_response) return;
    
	static dist = 64;
	
	var dir = point_direction(0, 0, spell.velocity.x, spell.velocity.z);
    dir -= self.direction;
    dir = (dir + 360) % 360;
	dir = round(dir / 90) * 90;
    
    if (dir % 180 == 0) return;
    
    dir += self.direction;
    
    self.movement_direction = new Vector3(dist * dcos(dir), 0, -dist * dsin(dir));
	
    self.target = self.CalculateMovementTarget();
	self.state.change("moving");
};

self.movement_direction = undefined;
self.CalculateMovementTarget = function() {
    if (self.movement_direction == undefined) return new Vector3(self.x, self.y, self.z);
    return new Vector3(self.x, self.y, self.z).Add(self.movement_direction);
};