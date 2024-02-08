event_inherited();

self.target = undefined;

self.state = new SnowState("idle")
	.add("idle", {
        update: function() {
            if (!self.IsGrounded()) {
                self.state.change("falling");
            }
        }
	})
	.add("falling", {
        update: function() {
            // properly do this later
            static grav = 9;
            static block_size = 32;
            self.yspeed -= grav * PDT;
            
            var step = abs(self.yspeed);
            var dir = sign(self.yspeed);
            repeat (step div block_size) {
                self.y += dir * block_size;
                self.cshapes[0].position.y += dir * block_size;
                
                if (obj_game.collision.CheckObject(self.cobjects[0])) {
                    self.y -= dir * block_size;
                    self.cshapes[0].position.y -= dir * block_size;
                    break;
                }
                
                step -= block_size;
            }
            
            repeat (step) {
                self.y += dir;
                self.cshapes[0].position.y += dir;
                
                if (obj_game.collision.CheckObject(self.cobjects[0])) {
                    self.y -= dir;
                    self.cshapes[0].position.y -= dir;
                    break;
                }
                
                //step -= 1;
            }
            
            if (self.IsGrounded()) {
                self.state.change("idle");
            }
            
            self.UpdateCollisionPositions();
        }
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
				self.state.change("idle");
			}
		}
	});

self.OnSpellHit = function(spell) {
    if (spell.object_index != self.spell_response) return;
    
	static dist = 64;
	
	var dir = point_direction(0, 0, spell.velocity.x, spell.velocity.z);
	dir = round(dir / 90) * 90;
	
    self.target = new Vector3(self.x + dist * dcos(dir), self.y, self.z - dist * dsin(dir));
	self.state.change("moving");
};

self.IsGrounded = function() {
    if (self.y <= 0) return true;
    
    self.cshapes[0].position.y -= 1;
    var grounded = obj_game.collision.CheckObject(self.cobjects[0]);
    self.cshapes[0].position.y += 1;
    return grounded;
};