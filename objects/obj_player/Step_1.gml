obj_game.active_camera = self.camera;

var look_sensitivity = 1 / 3;
var max_pitch = 80;
var mx = (input_cursor_x() - input_cursor_previous_x()) * look_sensitivity;
var my = (input_cursor_y() - input_cursor_previous_y()) * look_sensitivity;
self.camera.direction += mx;
self.camera.pitch = clamp(self.camera.pitch + my, -max_pitch, max_pitch);

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

var jump_speed = 3;
if (input_check_pressed("jump")) {
    if (self.y == 0) {
        self.yspeed = jump_speed;
    }
}

if (self.IsGrounded()) {
    if (self.yspeed < 0) {
        self.yspeed = 0;
    }
} else {
    var grav = 0.15;
    self.yspeed -= grav;
}

dy = self.yspeed;

var has_moved = point_distance(dx, dz, 0, 0);

var fov_run = 72;
var fov_walk = 60;
var fov_transition_speed = 0.05;

var target_fov = (has_moved && input_check("run")) ? fov_run : fov_walk;
self.camera.fov = lerp(self.camera.fov, target_fov, fov_transition_speed);

dx *= spd;
dy *= spd;
dz *= spd;

var final_dx = 0;
var final_dy = 0;
var final_dz = 0;

self.cobject.shape.position.x = self.x + dx;
self.cobject.shape.position.y = self.y + 16;
self.cobject.shape.position.z = self.z;

if (!obj_game.collision.CheckObject(self.cobject)) {
    final_dx = dx;
} else {
    for (var i = 1; i < abs(dx); i++) {
        self.cobject.shape.position.x = self.x + i * sign(dx);
        if (obj_game.collision.CheckObject(self.cobject)) {
            final_dx = (i - 1) * sign(dx);
            break;
        }
    }
}

self.cobject.shape.position.x = self.x;
self.cobject.shape.position.y = self.y + dy + 16;
self.cobject.shape.position.z = self.z;

if (!obj_game.collision.CheckObject(self.cobject)) {
    final_dy = dy;
} else {
    for (var i = 1; i < abs(dy); i++) {
        self.cobject.shape.position.y = self.y + 16 + i * sign(dy);
        if (obj_game.collision.CheckObject(self.cobject)) {
            final_dy = (i - 1) * sign(dy);
            break;
        }
    }
}

self.cobject.shape.position.x = self.x;
self.cobject.shape.position.y = self.y + 16;
self.cobject.shape.position.z = self.z + dz;

if (!obj_game.collision.CheckObject(self.cobject)) {
    final_dz = dz;
} else {
    for (var i = 1; i < abs(dz); i++) {
        self.cobject.shape.position.z = self.z + i * sign(dz);
        if (obj_game.collision.CheckObject(self.cobject)) {
            final_dz = (i - 1) * sign(dz);
            break;
        }
    }
}

self.x += final_dx;
self.y += final_dy;
self.z += final_dz;

if (self.y < 0) {
    self.y = 0;
}

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