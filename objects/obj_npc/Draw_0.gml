//matrix_set(matrix_world, matrix_build(self.x, self.y, self.z, 0, self.direction, 0, 1, 1, 1));

var character_sprites = CharacterSprites.duck;
var angle = (point_direction(self.x, self.z, obj_game.active_camera.x, obj_game.active_camera.z) + self.direction) % 360;
var current_sprite = character_sprites.front;
var matrix = matrix_build(self.x, self.y, self.z, 0, self.direction + 90, 0, 1, -1, 1);

if (angle < 45 || angle > 315) {
    // default values
} else if (angle < 135) {
    current_sprite = character_sprites.side;
    matrix = matrix_build(self.x, self.y, self.z, 0, self.direction, 0, 1, -1, 1);
} else if (angle < 225) {
    current_sprite = character_sprites.back;
    matrix = matrix_build(self.x, self.y, self.z, 0, self.direction + 90, 0, 1, -1, 1);
} else {
    current_sprite = character_sprites.side;
    matrix = matrix_build(self.x, self.y, self.z, 0, self.direction, 0, 1, -1, 1);
}

matrix_set(matrix_world, matrix);
draw_sprite(current_sprite, 0, 0, 0);

matrix_set(matrix_world, matrix_build_identity());