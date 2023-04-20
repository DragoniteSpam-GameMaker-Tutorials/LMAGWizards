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

var jump_speed = 4;
if (input_check_pressed("jump")) {
    if (self.y == 0) {
        self.yspeed = jump_speed;
    }
}

var grav = 0.15;
self.yspeed -= grav;
dy = self.yspeed;

var has_moved = point_distance(dx, dz, 0, 0);

var fov_run = 72;
var fov_walk = 60;
var fov_transition_speed = 0.05;

var target_fov = (has_moved && input_check("run")) ? fov_run : fov_walk;
self.camera.fov = lerp(self.camera.fov, target_fov, fov_transition_speed);

self.x += dx * spd;
self.y += dy;
self.z += dz * spd;

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