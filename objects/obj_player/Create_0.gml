event_inherited();

self.state = new SnowState("default", false);

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
        
        // properly do this later
        static grav = 9;
        self.yspeed -= grav * DT;
        
        self.HandleMovement();
        self.HandleClimbing();
        
        if (self.IsGrounded()) {
            self.state.change("default");
        }
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
        self.y += climb_speed * DT;
        
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
        self.advance_amount -= advance_speed * DT;
        
        self.x += dcos(self.direction) * advance_speed * DT;
        self.z += dsin(self.direction) * advance_speed * DT;
        
        if (self.advance_amount <= 0) {
            self.state.change("default");
        }
    }
});

self.climbing_target = undefined;

self.camera = new Camera(0, 250, 0, 1000, 0, 1000, 0, 1, 0, 60, 16 / 9, 1, 10000);

#region Special collision object - climb detection
var player_data = obj_game.meshes.player;
var player_climb_collision = array_search_with_name(player_data.collision_shapes, "#ClimbDetection");

var original_position = new Vector3(player_climb_collision.position.x, player_climb_collision.position.y, player_climb_collision.position.z);
var climb_shape = new ColSphere(original_position, player_climb_collision.radius);
climb_shape.original_position = original_position.Mul(1);
self.cobject_climb = new ColObject(climb_shape, self.id, ECollisionMasks.NONE, ECollisionMasks.CLIMBABLE);
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

// overrides obj_npc::IsGrounded
self.IsGrounded = function() {
    if (self.y <= 0) return true;
    
    self.cobject_grounded.shape.Set(new Vector3(self.x, self.y, self.z));
    return obj_game.collision.CheckObject(self.cobject_grounded);
};

self.UpdateCamera = function() {
	var camera_target = self.GetCameraTarget();
    
    self.camera.xto = camera_target.x;
    self.camera.yto = camera_target.y;
    self.camera.zto = camera_target.z;
    
    self.camera.x = self.camera.xto - self.camera.distance * dcos(self.camera.direction) * dcos(self.camera.pitch);
    self.camera.y = self.camera.yto + self.camera.distance * dsin(self.camera.pitch);
    self.camera.z = self.camera.zto + self.camera.distance * dsin(self.camera.direction) * dcos(self.camera.pitch);
};

self.HandleCamera = function() {
    obj_game.active_camera = self.camera;
    static look_sensitivity = 1 / 3;
    static max_pitch = 80;
    var mx = (input_cursor_x() - input_cursor_previous_x()) * look_sensitivity;
    var my = (input_cursor_y() - input_cursor_previous_y()) * look_sensitivity;
    self.camera.direction += mx;
    self.camera.pitch = clamp(self.camera.pitch + my, -max_pitch, max_pitch);
    
    static camera_speed = 600;
    static camera_min = 80;
    static camera_max = 240;
    
    if (input_check("camera_in")) {
        self.camera.distance -= camera_speed * DT;
    }
    if (input_check("camera_out")) {
        self.camera.distance += camera_speed * DT;
    }
    
    self.camera.distance = clamp(self.camera.distance, camera_min, camera_max);
};

self.HandleJump = function() {
    static jump_speed = 240;
    if (input_check_pressed("jump")) {
        self.yspeed = jump_speed * DT;
        self.state.change("airborne");
    }
};

self.HandleMovement = function() {
    var dx = 0;
    var dy = 0;
    var dz = 0;
    
    static speed_run = 300;
    static speed_walk = 180;
    var spd = (input_check("run") ? speed_run : speed_walk) * DT;
    
    if (input_check("up")) {
        dx += dcos(self.camera.direction);
        dz -= dsin(self.camera.direction);
        self.direction = 360 - self.camera.direction;
    }
    
    if (input_check("down")) {
        dx -= dcos(self.camera.direction);
        dz += dsin(self.camera.direction);
        self.direction = 360 - self.camera.direction;
    }
    
    if (input_check("right")) {
        dx -= dsin(self.camera.direction);
        dz -= dcos(self.camera.direction);
        self.direction = 360 - self.camera.direction;
    }
    
    if (input_check("left")) {
        dx += dsin(self.camera.direction);
        dz += dcos(self.camera.direction);
        self.direction = 360 - self.camera.direction;
    }
    
    self.xspeed = dx * spd;
    //self.yspeed *= spd;
    self.zspeed = dz * spd;
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

self.HandleCasting = function() {
    static spell_velocity = 640;
    static max_spell_range = 640;
    
    var potential_spell_target = undefined;
    
	var wand_target = self.GetCameraTarget();
    
    var dx = self.camera.xto - self.camera.x;
    var dy = self.camera.yto - self.camera.y;
    var dz = self.camera.zto - self.camera.z;
    var motion = new Vector3(dx, dy, dz).Normalize();
    var ray = new ColRay(wand_target, motion);
    
    var hit_info = obj_game.collision.CheckRay(ray);
    if (hit_info != undefined) {
        if (hit_info.distance <= max_spell_range) {
            var obj = hit_info.shape.object.reference;
            if (GameState.KnowsSpell(obj.spell_response)) {
                potential_spell_target = obj;
            }
        }
    }
    
    if (input_check("cast")) {
        // show the spell symbol or something
    }
    
    if (potential_spell_target != undefined && input_check_released("cast")) {
        var dx = self.camera.xto - self.camera.x;
        var dy = self.camera.yto - self.camera.y;
        var dz = self.camera.zto - self.camera.z;
        var motion = new Vector3(dx, dy, dz).Normalize().Mul(spell_velocity);
        var spell = instance_create_depth(wand_target.x, wand_target.y, wand_target.z, potential_spell_target.spell_response, {
            velocity: motion,
            caster: self.id
        });
    }
};