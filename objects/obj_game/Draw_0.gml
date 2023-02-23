gpu_set_cullmode(cull_counterclockwise);

self.camera.UpdateFree();
self.camera.Apply();

shader_set(shd_gbuff_main);
surface_set_target_ext(1, self.gbuff_depth);

draw_clear(c_black);

gpu_set_ztestenable(false);
gpu_set_zwriteenable(false);

matrix_set(matrix_world, matrix_build(self.camera.x, self.camera.y, self.camera.z, 0, 0, 0, 1, 1, 1));
self.meshes.skybox.Render();

gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);

matrix_set(matrix_world, matrix_build_identity());
self.meshes.ground.Render();

matrix_set(matrix_world, matrix_build(200, 0, 200, 0, 0, 0, 1, 1, 1));
self.meshes.block_singular.Render();
matrix_set(matrix_world, matrix_build_identity());

matrix_set(matrix_world, matrix_build(400, 0, 200, 0, 0, 0, 1, 1, 1));
self.meshes.chest.Render();
matrix_set(matrix_world, matrix_build_identity());

matrix_set(matrix_world, matrix_build(200, 0, 400, 0, 0, 0, 1, 1, 1));
self.meshes.barrel.Render();
matrix_set(matrix_world, matrix_build_identity());

matrix_set(matrix_world, matrix_build(400, 0, 400, 0, 0, 0, 1, 1, 1));
self.meshes.rock_pile_large.Render();
matrix_set(matrix_world, matrix_build_identity());

gpu_set_ztestenable(false);
gpu_set_zwriteenable(false);
gpu_set_cullmode(cull_noculling);