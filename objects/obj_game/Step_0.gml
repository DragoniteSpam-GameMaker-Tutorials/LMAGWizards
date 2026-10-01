if (keyboard_check(vk_escape)) game_end();
    
if (IS_EDITOR) {
    self.camera.UpdateFree();
    
    var mx = window_mouse_get_x();
    var my = window_mouse_get_y();
    
    if (mx > 0 and my > 0 and mx < window_get_width() and my < window_get_height()) {
        var world_vec = screen_to_world(mx, my, self.camera.view_mat, self.camera.proj_mat);
        var dx = world_vec[0];
        var dy = world_vec[1];
        var dz = world_vec[2];
        var mag = point_distance_3d(0, 0, 0, dx, dy, dz);
        dx /= mag;
        dy /= mag;
        dz /= mag;
        
        if (dy < 0) {
            var px = world_vec[3];
            var py = world_vec[4];
            var pz = world_vec[5];
            
            var m = -(py - Editor.cursor.floor_z) / dy;
            
            var hit_x = px + dx * m;
            var hit_y = py + dy * m;
            var hit_z = pz + dz * m;
            
            hit_x = round(hit_x / Editor.cursor.snapping) * Editor.cursor.snapping;
            //hit_y = round(hit_y / Editor.cursor.snapping) * Editor.cursor.snapping;
            hit_z = round(hit_z / Editor.cursor.snapping) * Editor.cursor.snapping;
            
            if (keyboard_check_pressed(vk_space)) {
                var selection = self.editor_ui.GetChild("OBJECT LIST").GetSelectedItem();
                if (!is_undefined(selection)) {
                    with (instance_create_depth(hit_x, hit_y, hit_z, selection)) {
                        self.UpdateCollisionPositions();
                    }
                }
            }
        }
    }
}