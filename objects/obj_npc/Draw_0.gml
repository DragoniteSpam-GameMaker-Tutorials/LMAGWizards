matrix_set(matrix_world, matrix_build(self.x, self.y, self.z, 0, self.direction, 0, 1, 1, 1));
obj_game.meshes.player.Render();
matrix_set(matrix_world, matrix_build_identity());