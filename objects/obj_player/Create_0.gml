event_inherited();

self.state = new SnowState("default", false);

self.bounce = {
    start: undefined,
    apex: undefined,
    target: undefined
};

self.state.add("default", {
    enter: function() {
        show_debug_message("enter the default state");
    },
    leave: function() {
        show_debug_message("leave the default state");
    },
    update: function() {
        self.HandleCamera();
        
        self.yspeed = 0;
        
        self.HandleJump();
        self.HandleMovement();
        self.HandleClimbing();
        self.HandleCasting();
        
        if (!self.IsGrounded()) {
            self.state.change("airborne");
        }
        
        self.UpdateActivatorPosition();
    }
}).add("airborne", {
    enter: function() {
        show_debug_message("enter the airborne state");
    },
    leave: function() {
        show_debug_message("leave the airborne state");
    },
    update: function() {
        self.HandleCamera();
        
		self.direction = 360 - obj_game.camera.direction;
        
        // properly do this later
        static grav_up = 12;
        static grav_down = grav_up * 1.8;
        
        if (self.yspeed > 0) {
            self.yspeed -= grav_up * PDT;
        } else {
            self.yspeed -= grav_down * PDT;
        }
        
        self.HandleMovement();
        self.HandleClimbing();
        
        if (self.IsGrounded()) {
            self.state.change("default");
        }
    }
}).add("bounce", {
    enter: function() {
        show_debug_message("enter the bounce state");
    },
    leave: function() {
        show_debug_message("leave the bounce state");
    },
    update: function() {
        self.HandleCamera();
        self.HandleCasting();
		self.direction = 360 - obj_game.camera.direction;
        
        var bounce_speed = 250;
        
        var start = new Vector3(self.bounce.start.x, 0, self.bounce.start.z);
        var current = new Vector3(self.x, 0, self.z);
        var target = new Vector3(self.bounce.target.x, 0, self.bounce.target.z);
        
        var new_position = current.Approach(target, bounce_speed * PDT);
        var diff = new_position.Sub(current);
        self.xspeed = diff.x;
        //self.yspeed = diff.y;
        self.zspeed = diff.z;
        
        var f = start.DistanceTo(new_position) / start.DistanceTo(target) * 2;
        
        if (f < 1) {
            self.y = ease_parabolic(self.bounce.start.y, self.bounce.apex.y, f, "start");
        } else {
			self.y = ease_parabolic(self.bounce.target.y, self.bounce.apex.y, f - 1, "finish");
        }
		
		self.HandleClimbing();
		
        if (self.IsGrounded()) {
            self.state.change("default");
        }
    },
	oncollision: function(displacement_vector) {
			self.state.change("airborne");
	}
}).add("climbing", {
    enter: function() {
        show_debug_message("enter the climbing state");
    },
    leave: function() {
        
    },
    update: function() {
        self.HandleCamera();
        
        self.xspeed = 0;
        self.yspeed = 0;
        self.zspeed = 0;
        
        static climb_speed = 60;
        self.y += climb_speed * PDT;
        
        if (self.y > self.climbing_target.shape.position.y + self.climbing_target.shape.size.y) {
            self.climbing_target = undefined;
            self.state.change("climbing advance");
        }
    }
}).add("climbing advance", {
    enter: function() {
        self.advance_amount = 24;
    },
    leave: function() {
        show_debug_message("leave the climbing state");
    },
    update: function() {
        self.HandleCamera();
        
        self.xspeed = 0;
        self.yspeed = 0;
        self.zspeed = 0;
        
        static advance_speed = 60;
        self.advance_amount -= advance_speed * PDT;
        
        self.x += dcos(self.direction) * advance_speed * PDT;
        self.z += dsin(self.direction) * advance_speed * PDT;
        
        if (self.advance_amount <= 0) {
            self.state.change("default");
        }
    }
});

self.climbing_target = undefined;

#region Special collision object - climb detection
var player_data = obj_game.meshes.player;
var player_climb_collision = array_search_with_name(player_data.collision_shapes, "#ClimbDetection");

var original_position = new Vector3(player_climb_collision.position.x, player_climb_collision.position.y, player_climb_collision.position.z);
var climb_shape = new ColSphere(original_position, player_climb_collision.radius);
climb_shape.original_position = original_position.Mul(1);
self.cobject_climb = new ColObject(climb_shape, self.id, ECollisionMasks.NONE, ECollisionMasks.CLIMBABLE);
#endregion

#region special collision object - pressure plate activator
var player_activator_collision = array_search_with_name(player_data.collision_shapes, "#Activator");

original_position = new Vector3(player_activator_collision.position.x, player_activator_collision.position.y, player_activator_collision.position.z);
var activator_shape = new ColAABB(original_position, player_activator_collision.scale);
activator_shape.original_position = original_position.Mul(1);
self.cobject_activator = new ColObject(activator_shape, self.id, ECollisionMasks.ACTIVATOR, ECollisionMasks.NONE);
#endregion

#region Special collision object - camera target
self.camera_target = array_search_with_name(player_data.collision_shapes, "#CameraTarget").position;

self.GetCameraTarget = function() {
	var player_transform = matrix_build(self.x, self.y, self.z, 0, self.direction, 0, 1, 1, 1);
    var camera_target_transformed = matrix_transform_vertex(player_transform, self.camera_target.x, self.camera_target.y, self.camera_target.z);
	return new Vector3(camera_target_transformed[0], camera_target_transformed[1], camera_target_transformed[2]);
};
#endregion

#region Special collision object - grounded platform
var player_grounded_collision = array_search_with_name(player_data.collision_shapes, "#Grounded");
var position = new Vector3(player_grounded_collision.position.x, player_grounded_collision.position.y, player_grounded_collision.position.z);
var scale = new Vector3(player_grounded_collision.scale.x, player_grounded_collision.scale.y, player_grounded_collision.scale.z);
self.cobject_grounded = new ColObject(new ColAABB(position, scale), self.id);
#endregion

self.spell_symbol = undefined;

// overrides obj_npc::IsGrounded
self.IsGrounded = function() {
    if (self.y <= 0) return true;
    
    self.cobject_grounded.shape.Set(new Vector3(self.x, self.y, self.z));
    return obj_game.collision.CheckObject(self.cobject_grounded);
};

self.DrawSpellSymbol = function() {
	if (self.spell_symbol != undefined && self.spell_symbol.obj.spell_response != undefined) {
		var info = self.spell_symbol;
        
		static cache = { };
		
		if (cache[$ string(info.obj.spell_response)] == undefined) {
			var inst = instance_create_depth(0, 0, 0, info.obj.spell_response);
			inst.lifespan = 0;
			cache[$ string(info.obj.spell_response)] = inst.sprite_index;
			instance_destroy(inst);
		}
		
		var symbol = cache[$ string(info.obj.spell_response)];
		
		gpu_set_ztestenable(false);
		gpu_set_zwriteenable(false);
		draw_sprite_billboard(symbol, 0, info.position.x, info.position.y, info.position.z, shd_gbuff_billboard_ripple);
		self.spell_symbol = undefined;
		gpu_set_ztestenable(true);
		gpu_set_zwriteenable(true);
	}
};

self.UpdateCamera = function() {
	var camera_target = self.GetCameraTarget();
    var camera = obj_game.camera;
    
    camera.xto = camera_target.x;
    camera.yto = camera_target.y;
    camera.zto = camera_target.z;
    
    camera.x = camera.xto - camera.distance * dcos(camera.direction) * dcos(camera.pitch);
    camera.y = camera.yto + camera.distance * dsin(camera.pitch);
    camera.z = camera.zto + camera.distance * dsin(camera.direction) * dcos(camera.pitch);
};

self.HandleCamera = function() {
    var camera = obj_game.camera;
    static look_sensitivity = 1 / 3;
    static max_pitch = 80;
    var mx = (input_cursor_x() - input_cursor_previous_x()) * look_sensitivity;
    var my = (input_cursor_y() - input_cursor_previous_y()) * look_sensitivity;
    camera.direction += mx;
    camera.pitch = clamp(camera.pitch + my, -max_pitch, max_pitch);
    
    static camera_speed = 600;
    static camera_min = 80;
    static camera_max = 240;
    
    if (input_check("camera_in")) {
        camera.distance -= camera_speed * PDT;
    }
    if (input_check("camera_out")) {
        camera.distance += camera_speed * PDT;
    }
    
    camera.distance = clamp(camera.distance, camera_min, camera_max);
};

self.HandleJump = function() {
    static jump_speed = 240;
    if (input_check_pressed("jump")) {
        self.yspeed = jump_speed * PDT;
        self.state.change("airborne");
    }
};

self.speed_current = 0;
self.direction_of_motion = 0;

self.HandleMovement = function() {
    var dx = 0;
    var dy = 0;
    var dz = 0;
    
    static speed_run = 300;
    static speed_walk = 180;
    var speed_target = 0;
    var is_running = input_check("run");
    
    var camera = obj_game.camera;
    
    if (input_check("up")) {
        dx += dcos(camera.direction);
        dz -= dsin(camera.direction);
        self.direction_of_motion = point_direction(0, 0, dx, dz);
        self.direction = 360 - camera.direction;
        speed_target = (is_running ? speed_run : speed_walk);
    }
    
    if (input_check("down")) {
        dx -= dcos(camera.direction);
        dz += dsin(camera.direction);
        self.direction_of_motion = point_direction(0, 0, dx, dz);
        self.direction = 360 - camera.direction;
        speed_target = (is_running ? speed_run : speed_walk);
    }
    
    if (input_check("right")) {
        dx -= dsin(camera.direction);
        dz -= dcos(camera.direction);
        self.direction_of_motion = point_direction(0, 0, dx, dz);
        self.direction = 360 - camera.direction;
        speed_target = (is_running ? speed_run : speed_walk);
    }
    
    if (input_check("left")) {
        dx += dsin(camera.direction);
        dz += dcos(camera.direction);
        self.direction_of_motion = point_direction(0, 0, dx, dz);
        self.direction = 360 - camera.direction;
        speed_target = (is_running ? speed_run : speed_walk);
    }
    
    dx =  dcos(self.direction_of_motion);
    dz = -dsin(self.direction_of_motion);
    
    static acceleration = 2000;
    static deceleration = 3000;
    if (speed_target == 0) {
        self.speed_current = approach(self.speed_current, speed_target, deceleration * PDT);
    } else {
        self.speed_current = approach(self.speed_current, speed_target, acceleration * PDT);
    }
    
    self.xspeed = dx * self.speed_current * PDT;
    //self.yspeed *= self.speed_current * PDT;
    self.zspeed = dz * self.speed_current * PDT;
};

self.HandleClimbing = function() {
    // deal with climbing
    if (input_check("up")) {
        var climb_position = self.cobject_climb.shape.original_position;
        var player_transform = matrix_build(self.x, self.y, self.z, 0, self.direction, 0, 1, 1, 1);
        var climb_target_transformed = matrix_transform_vertex(player_transform, climb_position.x, climb_position.y, climb_position.z);
        
        self.cobject_climb.shape.Set(new Vector3(climb_target_transformed[0], climb_target_transformed[1], climb_target_transformed[2]));
        
        var climb_object = obj_game.collision.CheckObject(self.cobject_climb);
        if (climb_object != undefined) {
            self.climbing_target = climb_object;
            self.state.change("climbing");
        }
    }
};

self.UpdateActivatorPosition = function() {
    var activator_position = self.cobject_activator.shape.original_position;
    var player_transform = matrix_build(self.x, self.y, self.z, 0, self.direction, 0, 1, 1, 1);
    var climb_target_transformed = matrix_transform_vertex(player_transform, activator_position.x, activator_position.y, activator_position.z);
    self.cobject_activator.shape.Set(new Vector3(climb_target_transformed[0], climb_target_transformed[1], climb_target_transformed[2]));
    
    obj_game.collision.Remove(self.cobject_activator);
    obj_game.collision.Add(self.cobject_activator);
};

self.HandleCasting = function() {
    static spell_velocity = 640;
    static max_spell_range = 640;
    
    var potential_spell_target = undefined;
    
	var wand_target = self.GetCameraTarget();
    var camera = obj_game.camera;
    
    var dx = camera.xto - camera.x;
    var dy = camera.yto - camera.y;
    var dz = camera.zto - camera.z;
    var motion = new Vector3(dx, dy, dz).Normalize();
    var ray = new ColRay(wand_target, motion);
    
    var hit_info = obj_game.collision.CheckRay(ray, ECollisionMasks.DEFAULT | ECollisionMasks.SPELL_TARGET);
    if (hit_info != undefined) {
        if (hit_info.distance <= max_spell_range) {
            var obj = hit_info.shape.object.reference;
            if (GameState.KnowsSpell(obj.spell_response)) {
                potential_spell_target = obj;
            }
        }
    }
	
    if (input_check("cast")) {
		if (potential_spell_target != undefined) {
			self.spell_symbol = {
				obj: potential_spell_target,
				position: hit_info.point
			};
		}
    }
    
    if (potential_spell_target != undefined && input_check_released("cast")) {
        var dx = camera.xto - camera.x;
        var dy = camera.yto - camera.y;
        var dz = camera.zto - camera.z;
        var motion = new Vector3(dx, dy, dz).Normalize().Mul(spell_velocity);
        var spell = instance_create_depth(wand_target.x, wand_target.y, wand_target.z, potential_spell_target.spell_response, {
            velocity: motion,
            caster: self.id
        });
    }
};

self.HandleBounce = function(apex, target) {
    static speed_threshold = -2;
    if (self.yspeed < speed_threshold) {
        self.yspeed = 0;
        self.bounce.start = new Vector3(self.x, self.y, self.z);
        self.bounce.apex = apex;
        self.bounce.target = target;
        self.state.change("bounce");
    }
};

self.HandleCollectables = function() {
	var original_group = self.cobject.group;
	self.cobject.group = ECollisionMasks.PICKUP;
	var collectable = obj_game.collision.CheckObject(self.cobject);
	if (collectable != undefined) {
		collectable.reference.OnCollection();
		with (collectable.reference) instance_destroy();
	}
	self.cobject.group = original_group;
};

self.OnCollision = function(displacement_vector) {
	self.state.oncollision(displacement_vector);
};