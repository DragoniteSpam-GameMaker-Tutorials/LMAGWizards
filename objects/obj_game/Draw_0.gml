gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);
gpu_set_cullmode(cull_counterclockwise);

self.camera.UpdateFree();
self.camera.Apply();

shader_set(shd_gbuff_main);
shader_set_uniform_f(shader_get_uniform(shd_gbuff_main, "u_CameraZFar"), self.camera.zfar);
surface_set_target_ext(1, self.gbuff_normal);
surface_set_target_ext(2, self.gbuff_depth);

draw_clear(c_black);

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