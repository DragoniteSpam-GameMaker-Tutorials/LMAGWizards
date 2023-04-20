var mx = (input_cursor_x() - input_cursor_previous_x()) / 3;
var my = (input_cursor_y() - input_cursor_previous_y()) / 3;
self.camera.direction += mx;
self.camera.pitch = clamp(self.camera.pitch + my, -80, 80);