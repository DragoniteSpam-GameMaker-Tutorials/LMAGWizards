#region Set up the render targets
gpu_set_cullmode(cull_counterclockwise);

self.camera.Apply();

shader_set(shd_gbuff_main);
surface_set_target_ext(1, self.gbuff_position);
surface_set_target_ext(2, self.gbuff_material);
surface_set_target_ext(3, self.gbuff_normal);

draw_clear(c_black);

self.camera.DrawSkybox(self.meshes.skybox);
#endregion

#region All of the stuff in the 3D world
material_set_material_type(EMaterialTypes.NORMAL);

matrix_set(matrix_world, matrix_build(-512, 0, 0, 0, 0, 0, 1, 1, 1));
self.meshes.ground.Render();
matrix_set(matrix_world, matrix_build_identity());
self.meshes.ground.Render();

with (obj_3d_object) event_perform(ev_draw, 0);
with (obj_spell) event_perform(ev_draw, 0);

shader_set(shd_gbuff_npc);
material_set_material_type(EMaterialTypes.NORMAL);
gpu_set_cullmode(cull_noculling);

with (obj_npc) event_perform(ev_draw, 0);
#endregion

Particles.Render();

obj_player.DrawSpellSymbol();

gpu_set_ztestenable(false);
gpu_set_zwriteenable(false);
gpu_set_cullmode(cull_noculling);