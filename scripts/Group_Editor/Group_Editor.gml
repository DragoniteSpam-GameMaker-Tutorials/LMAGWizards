function EditorInspectorSection(name, keys) constructor {
    self.name = name;
    self.keys = keys;
}

function EditorInspectorKey(key, type) constructor {
    self.key = key;
    self.type = type;
}

#macro Editor global.__editor__

Editor = {
    cursor: {
        floor_z: 0,
        snapping: 8
    },
    x: 0,
    y: 0,
    w: 400,
    h: 1080,
    spacing: 20,
    
    ui: undefined,
    
    Update: function() {
        obj_game.camera.UpdateFree();
    
        var mx = window_mouse_get_x();
        var my = window_mouse_get_y();
        
        if (mx > 0 and my > 0 and mx < window_get_width() and my < window_get_height()) {
            var world_vec = screen_to_world(mx, my, obj_game.camera.view_mat, obj_game.camera.proj_mat);
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
                
                var m = -(py - self.cursor.floor_z) / dy;
                
                var hit_x = px + dx * m;
                var hit_y = py + dy * m;
                var hit_z = pz + dz * m;
                
                hit_x = round(hit_x / self.cursor.snapping) * self.cursor.snapping;
                //hit_y = round(hit_y / self.cursor.snapping) * self.cursor.snapping;
                hit_z = round(hit_z / self.cursor.snapping) * self.cursor.snapping;
                
                if (keyboard_check_pressed(vk_space)) {
                    var selection = self.ui.GetChild("OBJECT LIST").GetSelectedItem();
                    if (!is_undefined(selection)) {
                        with (instance_create_depth(hit_x, hit_y, hit_z, selection)) {
                            self.UpdateCollisionPositions();
                        }
                    }
                }
            }
        }
    },
    
    DrawGUI: function() {
        draw_rectangle_colour(Editor.x, Editor.y, Editor.w, Editor.h, EMU_COLOR_BACK, EMU_COLOR_BACK, EMU_COLOR_BACK, EMU_COLOR_BACK, false);
        self.ui.Render(Editor.x, Editor.y);
    }
};

if (DEBUG) {
    var objects = tag_get_asset_ids("placeable", asset_object);
    array_sort(objects, true);
    
    Editor.ui = new EmuCore(Editor.x, Editor.y, Editor.w, Editor.h);
    Editor.ui.AddContent([
        new EmuList(Editor.spacing, EMU_AUTO, Editor.w - Editor.spacing * 2, Editor.spacing, "Available objects:", Editor.spacing, 16, function() {
            
        })
            .SetID("OBJECT LIST")
            .SetEntryTypes(E_ListEntryTypes.GM_OBJECT)
            .AddEntries(objects)
    ])
}