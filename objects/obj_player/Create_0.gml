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
        
        static grav = 0.15;
        self.yspeed -= grav;
        
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
        show_debug_message("leave the climbing state");
    },
    update: function() {
        self.HandleCamera();
        
        self.xspeed = 0;
        self.zspeed = 0;
        
        static climb_speed = 1;
        self.y += climb_speed;
    }
});

var player_data = obj_game.meshes.player;
var player_climb_collision = player_data.collision_shapes[array_find_index(player_data.collision_shapes, function(shape) {
    return shape.name == "#ClimbDetection";
})];
    
var original_position = new Vector3(player_climb_collision.position.x, player_climb_collision.position.y, player_climb_collision.position.z);
var climb_shape = new ColSphere(original_position, player_climb_collision.radius);
climb_shape.original_position = original_position.Mul(1);
self.cobject_climb = new ColObject(climb_shape, self.id, ECollisionMasks.NONE, ECollisionMasks.CLIMBABLE);

self.camera_target = player_data.collision_shapes[array_find_index(player_data.collision_shapes, function(shape) {
    return shape.name == "#CameraTarget";
})].position;

self.camera = new Camera(0, 250, 0, 1000, 0, 1000, 0, 1, 0, 60, 16 / 9, 1, 10000);

self.UpdateCamera = function() {
    var player_transform = matrix_build(self.x, self.y, self.z, 0, self.direction, 0, 1, 1, 1);
    var camera_target_transformed = matrix_transform_vertex(player_transform, self.camera_target.x, self.camera_target.y, self.camera_target.z);
    
    self.camera.xto = camera_target_transformed[0];
    self.camera.yto = camera_target_transformed[1];
    self.camera.zto = camera_target_transformed[2];
    
    self.camera.x = self.camera.xto - self.camera.distance * dcos(self.camera.direction) * dcos(self.camera.pitch);
    self.camera.y = self.camera.yto + self.camera.distance * dsin(self.camera.pitch);
    self.camera.z = self.camera.zto + self.camera.distance * dsin(self.camera.direction) * dcos(self.camera.pitch);
};

self.HandleCamera = function() {
    obj_game.active_camera = self.camera;
    var look_sensitivity = 1 / 3;
    var max_pitch = 80;
    var mx = (input_cursor_x() - input_cursor_previous_x()) * look_sensitivity;
    var my = (input_cursor_y() - input_cursor_previous_y()) * look_sensitivity;
    self.camera.direction += mx;
    self.camera.pitch = clamp(self.camera.pitch + my, -max_pitch, max_pitch);
    
    var camera_speed = 10;
    var camera_min = 80;
    var camera_max = 240;
    
    if (input_check("camera_in")) {
        self.camera.distance -= camera_speed;
    }
    if (input_check("camera_out")) {
        self.camera.distance += camera_speed;
    }
    
    self.camera.distance = clamp(self.camera.distance, camera_min, camera_max);
};

self.HandleJump = function() {
    static jump_speed = 4;
    if (input_check_pressed("jump")) {
        self.yspeed = jump_speed;
        self.state.change("airborne");
    }
};

self.HandleMovement = function() {
    var dx = 0;
    var dy = 0;
    var dz = 0;
    
    var speed_run = 5;
    var speed_walk = 3;
    var spd = input_check("run") ? speed_run : speed_walk;
    
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
        
        self.cobject_climb.shape.position.x = climb_target_transformed[0];
        self.cobject_climb.shape.position.y = climb_target_transformed[1];
        self.cobject_climb.shape.position.z = climb_target_transformed[2];
        
        if (obj_game.collision.CheckObject(self.cobject_climb)) {
            self.state.change("climbing");
        }
    }
};