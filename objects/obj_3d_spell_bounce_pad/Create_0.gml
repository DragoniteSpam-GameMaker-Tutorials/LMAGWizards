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
            if (obj_player.cobject.shape.CheckObject(self.cobjects[0])) {
                static speed_threshold = -2;
                if (obj_player.yspeed < speed_threshold) {
                    obj_player.yspeed = 0;
                    obj_player.bounce.start = new Vector3(obj_player.x, obj_player.y, obj_player.z);
                    obj_player.bounce.apex = self.apex;
                    obj_player.bounce.target = self.target;
                    obj_player.state.change("bounce");
                }
            }
		},
        draw_extras: function() {
            matrix_set(matrix_world, matrix_build(self.x, self.y, self.z, 0, 0, 0, 8, 8, 8));
            vertex_submit(obj_game.debug_sphere, pr_trianglelist, -1);
            matrix_set(matrix_world, matrix_build_identity());
        }
	})
    .add("deactivating", {
        enter: function() {
            self.state.change("inactive");
        }
    });

self.OnSpellHit = function(spell) {
    if (spell.object_index != self.spell_response) return;
    
    self.state.onspell();
};