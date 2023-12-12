event_inherited();

self.chest_angle = 0;

if (!self.can_be_unlocked) {
    self.spell_response = undefined;
}

self.ExpelContents = function() {
    var spawn = array_search_with_name(self.mesh.collision_shapes, "#SpawnOrigin").position;
    for (var i = 0, n = array_length(self.contents); i < n; i++) {
        var content = self.contents[i];
        var spawned = instance_create_depth(self.x + spawn.x, self.y + spawn.y, self.z + spawn.z, content.type, content.data);
        var hsp = random_range(56, 68);
        var vsp = random_range(100, 128);
        var dir = random_range(-30, 30) + self.direction - 270;
        spawned.xspeed = hsp * dcos(dir);
        spawned.yspeed = vsp;
        spawned.zspeed = -hsp * dsin(dir);
        spawned.is_moving = true;
        spawned.parent = self;
    }
};

self.state = new SnowState("closed", false)
	.add("closed", {
        enter: function() {
            if (!self.can_be_unlocked) {
                self.spell_response = obj_spell_unlock;
            }
        },
        leave: function() {
            self.spell_response = undefined;
        },
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