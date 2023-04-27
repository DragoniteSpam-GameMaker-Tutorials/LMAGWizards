// would use xprevious and zprevious, but we don't have zprevious, so i'll do it myself
var original_x = self.x;
var original_z = self.z;

event_inherited();

var has_moved = point_distance(self.x, self.z, original_x, original_z) > 1 /*world space units*/;

var fov_run = 72;
var fov_walk = 60;
var fov_transition_speed = 0.05;

var target_fov = (has_moved && input_check("run")) ? fov_run : fov_walk;
self.camera.fov = lerp(self.camera.fov, target_fov, fov_transition_speed);

self.UpdateCamera();