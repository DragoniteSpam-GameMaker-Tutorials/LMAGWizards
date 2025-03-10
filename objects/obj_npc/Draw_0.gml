//matrix_set(matrix_world, matrix_build(self.x, self.y, self.z, 0, self.direction, 0, 1, 1, 1));
matrix_set(matrix_world, matrix_build(self.x, self.y, self.z, 0, 0, 0, 1, -1, 1));

var character_sprites = CharacterSprites.duck;
var current_sprite = character_sprites.front;
draw_sprite(current_sprite, 0, 0, 0);

matrix_set(matrix_world, matrix_build_identity());