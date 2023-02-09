shader_set(shd_deferred);
shader_set_uniform_f(shader_get_uniform(shd_deferred, "u_CameraZFar"), self.camera.zfar);
shader_set_uniform_f(shader_get_uniform(shd_deferred, "u_FOVScale"), dtan(-self.camera.fov * self.camera.aspect / 2), dtan(-self.camera.fov / 2));

texture_set_stage(shader_get_sampler_index(shd_deferred, "samp_Normal"), surface_get_texture(self.gbuff_normal));
texture_set_stage(shader_get_sampler_index(shd_deferred, "samp_Depth"), surface_get_texture(self.gbuff_depth));
draw_surface(application_surface, 0, 0);

shader_reset();

draw_surface_ext(self.gbuff_normal, 0, 0, 0.25, 0.25, 0, c_white, 1);
draw_surface_ext(self.gbuff_depth, 0, 256, 0.25, 0.25, 0, c_white, 1);