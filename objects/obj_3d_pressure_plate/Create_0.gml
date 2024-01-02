event_inherited();

self.mesh = obj_game.meshes.button;

self.state = new SnowState("unpressed", false)
	.add("unpressed", {
        onspell: function() {
            self.state.change("pressed");
        },
        update: function() {
        }
	})/*
	.add("activating", {
        update: function() {
            static target_offset = -6;
            static movement_speed = 12;
            self.button_offset = approach(self.button_offset, target_offset, movement_speed * DT);
            if (self.button_offset == target_offset) {
                self.state.change("active");
            }
        }
	})*/
	.add("pressed", {
        enter: function() {
            self.OnActivation();
            if (self.infinite_use) {
                self.state.change("unpressed");
            }
        }
	})/*
	.add("deactivating", {
        update: function() {
            static target_offset = 0;
            static movement_speed = 4;
            self.button_offset = approach(self.button_offset, target_offset, movement_speed * DT);
            if (self.button_offset == target_offset) {
                self.state.change("primed");
            }
        }
	})*/;