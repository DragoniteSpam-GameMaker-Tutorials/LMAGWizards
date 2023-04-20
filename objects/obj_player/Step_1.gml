obj_game.active_camera = self.camera;

var mx = (input_cursor_x() - input_cursor_previous_x()) / 3;
var my = (input_cursor_y() - input_cursor_previous_y()) / 3;
self.camera.direction += mx;
self.camera.pitch = clamp(self.camera.pitch + my, -80, 80);

var dx = 0;
var dy = 0;
var dz = 0;

var spd = input_check("run") ? 5 : 3;

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

var has_moved = point_distance(dx, dz, 0, 0);

var target_fov = (has_moved && input_check("run")) ? 72 : 60;
self.camera.fov = lerp(self.camera.fov, target_fov, 0.05);

self.x += dx * spd;
self.y += dy * spd;
self.z += dz * spd;

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