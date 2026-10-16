function EditorInspectorSection(name, keys) constructor {
    self.name = name;
    self.keys = keys;
}

function EditorInspectorKey(key, type) constructor {
    self.key = key;
    self.type = type;
}

enum EditorGizmos {
    NONE,
    X,
    Y,
    Z
}

enum EditorGizmoModes {
    NONE,
    TRANSLATE,
    ROTATE,
    SCALE
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
    
    selected_gizmo: EditorGizmos.NONE,
    selected_gizmo_position: undefined,
    gizmo_type: EditorGizmoModes.ROTATE,
    
    ui: undefined,
    
    GetSelectionCenter: function() {
        var selected = self.ui.GetChild("ALL THINGS").GetAllSelectedItems();
        
        var min_x = infinity;
        var min_y = infinity;
        var min_z = infinity;
        var max_x = -infinity;
        var max_y = -infinity;
        var max_z = -infinity;
        
        for (var i = 0, n = array_length(selected); i < n; i++) {
            var thing = selected[i];
            min_x = min(min_x, thing.x);
            min_y = min(min_y, thing.y);
            min_z = min(min_z, thing.z);
            max_x = max(max_x, thing.x);
            max_y = max(max_y, thing.y);
            max_z = max(max_z, thing.z);
        };
        
        return new Vector3(
            mean(min_x, max_x),
            mean(min_y, max_y),
            mean(min_z, max_z)
        );
    },
    
    GetSelectionPlaneMouseLocation: function() {
        var selected_center = self.GetSelectionCenter();
        
        var mx = window_mouse_get_x();
        var my = window_mouse_get_y();
        
        var mouse_dir = obj_game.camera.GetMouseVector(mx, my);
        var mouse_pos = new Vector3(obj_game.camera.x, obj_game.camera.y, obj_game.camera.z);
        var ray = new ColRay(mouse_pos, mouse_dir);
        
        static test_plane_plus = new ColObject(undefined, undefined);
        static test_plane_minu = new ColObject(undefined, undefined);
        
        static plane_x_plus = new ColPlane(new Vector3( 1, 0, 0), 0);
        static plane_x_minu = new ColPlane(new Vector3(-1, 0, 0), 0);
        static plane_y_plus = new ColPlane(new Vector3(0,  1, 0), 0);
        static plane_y_minu = new ColPlane(new Vector3(0, -1, 0), 0);
        static plane_z_plus = new ColPlane(new Vector3(0, 0,  1), 0);
        static plane_z_minu = new ColPlane(new Vector3(0, 0, -1), 0);
        static ray_hit_info = new RaycastHitInformation();
        ray_hit_info.Clear();
        
        switch (self.gizmo_type) {
            // when you translate, you can use any plane that isn't the axis
            // of translation
            case EditorGizmoModes.TRANSLATE:
            case EditorGizmoModes.SCALE: {
                switch (self.selected_gizmo) {
                    case EditorGizmos.X: {
                        plane_z_plus.distance = selected_center.z;
                        plane_z_minu.distance = selected_center.z;
                        test_plane_plus.shape = plane_z_plus;
                        test_plane_minu.shape = plane_z_minu;
                    } break;
                    case EditorGizmos.Y: {
                        plane_x_plus.distance = selected_center.x;
                        plane_x_minu.distance = selected_center.x;
                        test_plane_plus.shape = plane_x_plus;
                        test_plane_minu.shape = plane_x_minu;
                    } break;
                    case EditorGizmos.Z: {
                        plane_y_plus.distance = selected_center.y;
                        plane_y_minu.distance = selected_center.y;
                        test_plane_plus.shape = plane_y_plus;
                        test_plane_minu.shape = plane_y_minu;
                    } break;
                }
            } break;
            case EditorGizmoModes.ROTATE: {
                switch (self.selected_gizmo) {
                    case EditorGizmos.X: {
                        plane_x_plus.distance = selected_center.x;
                        plane_x_minu.distance = selected_center.x;
                        test_plane_plus.shape = plane_x_plus;
                        test_plane_minu.shape = plane_x_minu;
                    } break;
                    case EditorGizmos.Y: {
                        plane_y_plus.distance = selected_center.y;
                        plane_y_minu.distance = selected_center.y;
                        test_plane_plus.shape = plane_y_plus;
                        test_plane_minu.shape = plane_y_minu;
                    } break;
                    case EditorGizmos.Z: {
                        plane_z_plus.distance = selected_center.z;
                        plane_z_minu.distance = selected_center.z;
                        test_plane_plus.shape = plane_z_plus;
                        test_plane_minu.shape = plane_z_minu;
                    } break;
                }
            } break;
        }
        
        if (test_plane_plus.CheckRay(ray, ray_hit_info)) {
            return ray_hit_info.point;
        }
        
        if (test_plane_minu.CheckRay(ray, ray_hit_info)) {
            return ray_hit_info.point;
        }
        
        return new Vector3(0, 0, 0);
    },
    
    Update: function() {
        obj_game.camera.UpdateFree();
    
        var mx = window_mouse_get_x();
        var my = window_mouse_get_y();
        
        var all_things = self.ui.GetChild("ALL THINGS");
        
        var mouse_dir = obj_game.camera.GetMouseVector(mx, my);
        var mouse_pos = new Vector3(obj_game.camera.x, obj_game.camera.y, obj_game.camera.z);
        var ray = new ColRay(mouse_pos, mouse_dir);
        
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
        
        var selected = self.ui.GetChild("ALL THINGS").GetAllSelectedItems();
        var selected_center = self.GetSelectionCenter();
        
        if (!mouse_check_button(mb_left)) {
            self.selected_gizmo = EditorGizmos.NONE;
            self.selected_gizmo_position = undefined;
        }
        
        static editor_gizmo_translate = function(selected, delta) {
            switch (self.selected_gizmo) {
                case EditorGizmos.X: {
                    for (var i = 0, n = array_length(selected); i < n; i++) {
                        var thing = selected[i];
                        thing.x += delta.x;
                        thing.UpdateCollisionPositions();
                    }
                } break;
                case EditorGizmos.Y: {
                    for (var i = 0, n = array_length(selected); i < n; i++) {
                        var thing = selected[i];
                        thing.y += delta.y;
                        thing.UpdateCollisionPositions();
                    }
                } break;
                case EditorGizmos.Z: {
                    for (var i = 0, n = array_length(selected); i < n; i++) {
                        var thing = selected[i];
                        thing.z += delta.z;
                        thing.UpdateCollisionPositions();
                    }
                } break;
            }
        };
        
        static editor_gizmo_rotate = function(selected, delta) {
            switch (self.selected_gizmo) {
                case EditorGizmos.X: {
                    var R = matrix_build(0, 0, 0, delta.z, 0, 0, 1, 1, 1);
                    for (var i = 0, n = array_length(selected); i < n; i++) {
                        var thing = selected[i];
                        matrix_multiply(thing.rotation_mat, R, thing.rotation_mat);
                        thing.UpdateCollisionPositions();
                    }
                } break;
                case EditorGizmos.Y: {
                    var R = matrix_build(0, 0, 0, 0, delta.x, 0, 1, 1, 1);
                    for (var i = 0, n = array_length(selected); i < n; i++) {
                        var thing = selected[i];
                        matrix_multiply(thing.rotation_mat, R, thing.rotation_mat);
                        thing.UpdateCollisionPositions();
                    }
                } break;
                case EditorGizmos.Z: {
                    var R = matrix_build(0, 0, 0, 0, 0, delta.y, 1, 1, 1);
                    for (var i = 0, n = array_length(selected); i < n; i++) {
                        var thing = selected[i];
                        matrix_multiply(thing.rotation_mat, R, thing.rotation_mat);
                        thing.UpdateCollisionPositions();
                    }
                } break;
            }
        }
        
        if (mouse_check_button_pressed(mb_left)) {
            static mouse_surf = -1;
            mouse_surf = surface_validate(mouse_surf, surface_get_width(application_surface), surface_get_height(application_surface));
            
            // figure out what you clicked on
            surface_set_target(mouse_surf);
            
                obj_game.camera.Apply();
                draw_clear(c_black);
                
                matrix_set(matrix_world, matrix_build(selected_center.x, selected_center.y, selected_center.z, 0, 0, 0, 25, 25, 25));
                gpu_set_ztestenable(true);
                shader_reset();
            
                switch (self.gizmo_type) {
                    case EditorGizmoModes.TRANSLATE: {
                        obj_game.gizmos.translate_x.Render();
                        obj_game.gizmos.translate_y.Render();
                        obj_game.gizmos.translate_z.Render();
                    } break;
                    case EditorGizmoModes.ROTATE: {
                        obj_game.gizmos.rotate_x.Render();
                        obj_game.gizmos.rotate_y.Render();
                        obj_game.gizmos.rotate_z.Render();
                    } break;
                    case EditorGizmoModes.SCALE: {
                        obj_game.gizmos.scale_x.Render();
                        obj_game.gizmos.scale_y.Render();
                        obj_game.gizmos.scale_z.Render();
                    } break;
                }
                
                matrix_set(matrix_world, matrix_build_identity());
                gpu_set_ztestenable(true);
            
            surface_reset_target();
            
            // yes this is slow
            var mouse_pick_color = surface_getpixel(mouse_surf, mx, my);
            
            if (mouse_pick_color == #fe3232) {
                self.selected_gizmo = EditorGizmos.X;
            } else if (mouse_pick_color == #32fe32) {
                self.selected_gizmo = EditorGizmos.Y;
            } else if (mouse_pick_color == #3232fe) {
                self.selected_gizmo = EditorGizmos.Z;
            }
            
            // code that happens when you first select a gizmo thingy
            if (self.selected_gizmo != EditorGizmos.NONE) {
                self.selected_gizmo_position = self.GetSelectionPlaneMouseLocation();
            // code that happens when you have not selected a gizmo thingy
            } else {
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
        }
        
        if (mouse_check_button(mb_left)) {
            if (self.selected_gizmo != EditorGizmos.NONE) {
                var current_gizmo_mouse_position = self.GetSelectionPlaneMouseLocation();
                if (current_gizmo_mouse_position != undefined && self.selected_gizmo_position != undefined) {
                    var delta = current_gizmo_mouse_position.Sub(self.selected_gizmo_position);
                    
                    switch (self.gizmo_type) {
                        case EditorGizmoModes.TRANSLATE: {
                            editor_gizmo_translate(selected, delta);
                        } break;
                        case EditorGizmoModes.ROTATE: {
                            editor_gizmo_rotate(selected, delta);
                        } break;
                    }
                    
                    self.selected_gizmo_position = current_gizmo_mouse_position;
                }
            }
        }
        
        if (keyboard_check_pressed(vk_delete)) {
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
        shader_set_uniform_f(shader_get_uniform(shd_gbuff_editor, "u_time_enabled"), 1);
        shader_set_uniform_f(shader_get_uniform(shd_gbuff_editor, "u_override_color"), 0, 0, 0, 0);
        
        var selected = self.ui.GetChild("ALL THINGS").GetAllSelectedItems();
        var center = self.GetSelectionCenter();
        
        for (var i = 0, n = array_length(selected); i < n; i++) {
            var thing = selected[i];
            with (thing) {
                event_perform(ev_draw, 0);
            }
        };
        
        shader_set_uniform_f(shader_get_uniform(shd_gbuff_editor, "u_time_enabled"), 0);
        matrix_set(matrix_world, matrix_build(center.x, center.y, center.z, 0, 0, 0, 25, 25, 25));
        gpu_set_ztestenable(false);
        
        static set_override_color = function(enabled) {
            shader_set_uniform_f(shader_get_uniform(shd_gbuff_editor, "u_override_color"), $ff / 255, $ff / 255, $99 / 255, enabled);
        };
        
        switch (self.gizmo_type) {
            case EditorGizmoModes.TRANSLATE: {
                set_override_color(self.selected_gizmo == EditorGizmos.X);
                obj_game.gizmos.translate_x.Render();
                set_override_color(self.selected_gizmo == EditorGizmos.Y);
                obj_game.gizmos.translate_y.Render();
                set_override_color(self.selected_gizmo == EditorGizmos.Z);
                obj_game.gizmos.translate_z.Render();
            } break;
            case EditorGizmoModes.ROTATE: {
                set_override_color(self.selected_gizmo == EditorGizmos.X);
                obj_game.gizmos.rotate_x.Render();
                set_override_color(self.selected_gizmo == EditorGizmos.Y);
                obj_game.gizmos.rotate_y.Render();
                set_override_color(self.selected_gizmo == EditorGizmos.Z);
                obj_game.gizmos.rotate_z.Render();
            } break;
            case EditorGizmoModes.SCALE: {
                set_override_color(self.selected_gizmo == EditorGizmos.X);
                obj_game.gizmos.scale_x.Render();
                set_override_color(self.selected_gizmo == EditorGizmos.Y);
                obj_game.gizmos.scale_y.Render();
                set_override_color(self.selected_gizmo == EditorGizmos.Z);
                obj_game.gizmos.scale_z.Render();
            } break;
        }
        
        matrix_set(matrix_world, matrix_build_identity());
        gpu_set_ztestenable(true);
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
                .SetList(global.all_things)
        ])
    }
};