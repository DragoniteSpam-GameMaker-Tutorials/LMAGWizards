var mx = (input_cursor_x() - input_cursor_previous_x()) / 3;
var my = (input_cursor_y() - input_cursor_previous_y()) / 3;
self.camera.direction += mx;
self.camera.pitch = clamp(self.camera.pitch + my, -80, 80);

var dx = 0;
var dy = 0;
var dz = 0;

var spd = 4;

if (keyboard_check(ord("W"))) {
    dx += dcos(self.camera.direction);
    dz -= dsin(self.camera.direction);
    self.direction = direction;
}

if (keyboard_check(ord("S"))) {
    dx -= dcos(self.camera.direction);
    dz += dsin(self.camera.direction);
    self.direction = direction;
}

if (keyboard_check(ord("D"))) {
    dx -= dsin(self.camera.direction);
    dz -= dcos(self.camera.direction);
    self.direction = direction;
}

if (keyboard_check(ord("A"))) {
    dx += dsin(self.camera.direction);
    dz += dcos(self.camera.direction);
    self.direction = direction;
}

self.x += dx * spd;
self.y += dy * spd;
self.z += dz * spd;
        