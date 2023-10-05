var target_size = Video.GetRenderingResolution();

surface_resize(application_surface, target_size.x, target_size.y);
self.gbuff_position = surface_validate(self.gbuff_position, target_size.x, target_size.y, surface_rgba32float);
self.gbuff_material = surface_validate(self.gbuff_material, target_size.x, target_size.y, surface_r8unorm);
self.gbuff_normal = surface_validate(self.gbuff_normal, target_size.x, target_size.y, surface_rgba8unorm);