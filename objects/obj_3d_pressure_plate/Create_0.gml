event_inherited();

self.mesh = obj_game.meshes.pressure_plate;

self.Activate = function() {
};

self.Deactivate = function() {
};

self.GetActivationZone = function() {
    var index = array_find_index(self.mesh.collision_shapes, function(item) {
        return item.name == "#Activation";
    });
    return self.cobjects[index];
};

self.state = new SnowState("unpressed", false)
	.add("unpressed", {
        leave: function() {
            self.Activate();
        },
        update: function() {
            var activation_object = self.GetActivationZone();
            activation_object.mask = ECollisionMasks.DEFAULT;
            activation_object.group = ECollisionMasks.DEFAULT;
            if (obj_game.collision.CheckObject(activation_object) || obj_player.cobject.shape.CheckObject(activation_object)) {
                self.state.change("pressed");
            }
            activation_object.mask = ECollisionMasks.NONE;
        }
	})
	.add("pressed", {
        leave: function() {
            self.Deactivate();
        },
        update: function() {
            var activation_object = self.GetActivationZone();
            if (!(obj_game.collision.CheckObject(activation_object) || obj_player.cobject.shape.CheckObject(activation_object))) {
                self.state.change("unpressed");
            }
        }
	});