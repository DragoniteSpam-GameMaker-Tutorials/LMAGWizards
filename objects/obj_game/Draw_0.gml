#region Set up the render targets
gpu_set_cullmode(cull_counterclockwise);

self.active_camera.Apply();

shader_set(shd_gbuff_main);
surface_set_target_ext(1, self.gbuff_position);
surface_set_target_ext(2, self.gbuff_material);

draw_clear(c_black);

self.active_camera.DrawSkybox(self.meshes.skybox);
#endregion

#region All of the stuff in the 3D world
material_set_material_type(EMaterialTypes.NORMAL);

matrix_set(matrix_world, matrix_build_identity());
self.meshes.ground.Render();

with (obj_entity) {
    event_perform(ev_draw, 0);
}
#endregion

Particles.Render();

gpu_set_ztestenable(false);
gpu_set_zwriteenable(false);
gpu_set_cullmode(cull_noculling);