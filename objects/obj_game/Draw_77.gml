shader_set(shd_deferred);

cluck_set_light_ambient(#404040);
cluck_set_light_point(0, c_white, 250, 32, 250, 160);
cluck_set_light_point(1, c_red, 400, 32, 250, 160);
cluck_set_light_direction(2, c_dkgray, -1, -1, -1);
cluck_set_light_spot(3, c_yellow, self.camera.x, self.camera.y, self.camera.z, self.camera.xto - self.camera.x, self.camera.yto - self.camera.y, self.camera.zto - self.camera.z, 400, 45, 30);
cluck_set_fog(true, c_white, 1, 500, 1000);
cluck_apply(shd_deferred, self.camera.GetViewMat());

gpu_set_tex_filter(true);

texture_set_stage(shader_get_sampler_index(shd_deferred, "samp_Position"), surface_get_texture(self.gbuff_position));
texture_set_stage(shader_get_sampler_index(shd_deferred, "samp_Material"), surface_get_texture(self.gbuff_material));
draw_surface_stretched(application_surface, 0, 0, window_get_width(), window_get_height());

gpu_set_tex_filter(false);

shader_reset();

if (keyboard_check(vk_tab)) {
    draw_surface_ext(application_surface, 0, 0, 0.25, 0.25, 0, c_white, 1);
    draw_surface_ext(self.gbuff_position, 0, 216, 0.25, 0.25, 0, c_white, 1);
    draw_surface_ext(self.gbuff_material, 0, 432, 0.25, 0.25, 0, c_white, 1);
}