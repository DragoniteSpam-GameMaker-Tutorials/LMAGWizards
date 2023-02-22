shader_set(shd_deferred);


cluck_set_light_ambient(#404040);
cluck_set_light_point(0, c_white, 250, 32, 250, 160);
cluck_set_light_point(1, c_red, 400, 32, 250, 160);
cluck_set_fog(true, c_white, 1, 500, 1000);
cluck_apply(shd_deferred, self.camera.GetViewMat());

texture_set_stage(shader_get_sampler_index(shd_deferred, "samp_Depth"), surface_get_texture(self.gbuff_depth));
draw_surface(application_surface, 0, 0);

shader_reset();

draw_surface_ext(self.gbuff_depth, 0, 256, 0.25, 0.25, 0, c_white, 1);