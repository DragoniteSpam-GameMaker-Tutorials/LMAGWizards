//matrix_set(matrix_world, matrix_build(self.x, self.y, self.z, 0, self.direction, 0, 1, 1, 1));

self.state.sprites();

var angle = (point_direction(self.x, self.z, obj_game.camera.x, obj_game.camera.z) + self.direction) % 360;
var matrix = matrix_build(self.x, self.y, self.z, 0, self.direction + 90, 0, 1, -1, 1);

if (angle < 45 || angle > 315) {
    // default values
} else if (angle < 135) {
    matrix = matrix_build(self.x, self.y, self.z, 0, self.direction, 0, 1, -1, 1);
} else if (angle < 225) {
    matrix = matrix_build(self.x, self.y, self.z, 0, self.direction + 90, 0, 1, -1, 1);
} else {
    matrix = matrix_build(self.x, self.y, self.z, 0, self.direction, 0, 1, -1, 1);
}

matrix_set(matrix_world, matrix);
draw_sprite(self.sprite_index, self.image_index, 0, 0);

matrix_set(matrix_world, matrix_build_identity());