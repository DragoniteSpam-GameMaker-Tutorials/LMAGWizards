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
        
        var all_things = self.ui.GetChild("ALL THINGS");
        
        var mouse_dir = obj_game.camera.GetMouseVector(mx, my);
        var mouse_pos = new Vector3(obj_game.camera.x, obj_game.camera.y, obj_game.camera.z);
        
        if (mx > 0 and my > 0 and mx < window_get_width() and my < window_get_height()) {
            if (mouse_dir.y < 0) {
                var m = -(mouse_pos.y - self.cursor.floor_z) / mouse_dir.y;
                
                var hit_x = mouse_pos.x + mouse_dir.x * m;
                var hit_y = mouse_pos.y + mouse_dir.y * m;
                var hit_z = mouse_pos.z + mouse_dir.z * m;
                
                hit_x = round(hit_x / self.cursor.snapping) * self.cursor.snapping;
                //hit_y = round(hit_y / self.cursor.snapping) * self.cursor.snapping;
                hit_z = round(hit_z / self.cursor.snapping) * self.cursor.snapping;
                
                if (keyboard_check_pressed(vk_space)) {
                    var selection = self.ui.GetChild("OBJECT LIST").GetSelectedItem();
                    if (!is_undefined(selection)) {
                        with (instance_create_depth(hit_x, hit_y, hit_z, selection)) {
                            self.SetMesh(obj_game.meshes.block);
                            self.UpdateCollisionPositions();
                        }
                    }
                }
            }
        }
        
        if (mouse_check_button_pressed(mb_left)) {
            var ray = new ColRay(mouse_pos, mouse_dir);
            var raycast_result = obj_game.collision.CheckRay(ray, ~0);
            
            if (!keyboard_check(vk_control)) {
                all_things.ClearSelection();
            }
            
            if (!is_undefined(raycast_result)) {
                var what = raycast_result.shape.object.reference;
                var all_things_index = array_get_index(global.all_things, what);
                if (all_things_index >= 0){
                    all_things.Select(all_things_index, true);
                }
            }
        }
        
        if (keyboard_check_pressed(vk_delete)) {
            var selected = self.ui.GetChild("ALL THINGS").GetAllSelectedItems();
            array_foreach(selected, function(thing) {
                if (instance_exists(thing)) {
                    instance_destroy(thing);
                }
            });
            self.ui.GetChild("ALL THINGS").ClearSelection();
        }
    },
    
    Draw: function() {
        shader_set(shd_gbuff_editor);
        shader_set_uniform_f(shader_get_uniform(shd_gbuff_editor, "u_time"), current_time / 1000 * 5);
        
        var selected = self.ui.GetChild("ALL THINGS").GetAllSelectedItems();
        array_foreach(selected, function(thing) {
            with (thing) {
                event_perform(ev_draw, 0);
            }
        });
        
        shader_reset();
    },
    
    DrawGUI: function() {
        draw_rectangle_colour(Editor.x, Editor.y, Editor.w, Editor.h, EMU_COLOR_BACK, EMU_COLOR_BACK, EMU_COLOR_BACK, EMU_COLOR_BACK, false);
        self.ui.Render(Editor.x, Editor.y);
    },
    
    InitUI: function() {
        var objects = tag_get_asset_ids("placeable", asset_object);
        array_sort(objects, true);
        
        Editor.ui = new EmuCore(Editor.x, Editor.y, Editor.w, Editor.h);
        Editor.ui.AddContent([
            new EmuList(Editor.spacing, EMU_AUTO, Editor.w - Editor.spacing * 2, Editor.spacing, "Available objects:", Editor.spacing, 16, function() {
                
            })
                .SetID("OBJECT LIST")
                .SetEntryTypes(E_ListEntryTypes.GM_OBJECT)
                .AddEntries(objects),
            new EmuList(Editor.spacing, EMU_AUTO, Editor.w - Editor.spacing * 2, Editor.spacing, "All of the things:", Editor.spacing, 30, function() {
                
            })
                .SetID("ALL THINGS")
                .SetMultiSelect(true, false, false)
                .SetEntryTypes(E_ListEntryTypes.GM_INSTANCE)
                .AddEntries(global.all_things),
        ])
    }
};