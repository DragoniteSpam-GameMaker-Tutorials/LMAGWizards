event_inherited();

var t = current_time / 1000;
var bounce = 1.5 * sin(t * 3);

self.rotation_mat = matrix_build(0, bounce, 0, 0, t * 120, 0, 1, 1, 1);