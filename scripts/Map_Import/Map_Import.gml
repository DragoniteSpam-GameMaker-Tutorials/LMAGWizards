function UnityMapImport(filename, meshes) constructor {
    static header_value = "derg map";
    
    var buffer = buffer_load(filename);
    
    var header = buffer_read(buffer, buffer_string);
    
    if (header != header_value) {
        buffer_delete(buffer);
        return;
    }
    
    var version = buffer_read(buffer, buffer_s32);
    
    var mesh_mapping_count = buffer_read(buffer, buffer_s32);
    var mesh_lookup = array_create(mesh_mapping_count);
    var mesh_name_lookup = array_create(mesh_mapping_count);
    for (var i = 0; i < mesh_mapping_count; i++) {
        var name = string_lower(buffer_read(buffer, buffer_string));
        mesh_lookup[i] = meshes[$ name];
        mesh_name_lookup[i] = name;
    }
    
    var texture_mapping_count = buffer_read(buffer, buffer_s32);
    var texture_lookup = array_create(texture_mapping_count);
    for (var i = 0; i < texture_mapping_count; i++) {
        var name = string_lower(buffer_read(buffer, buffer_string));
        texture_lookup[i] = asset_get_index(name);
    }
    
    self.objects = array_create(buffer_read(buffer, buffer_s32));
    
    for (var i = 0, n = array_length(self.objects); i < n; i++) {
        var xx = -buffer_read(buffer, buffer_f32);
        var yy = buffer_read(buffer, buffer_f32);
        var zz = buffer_read(buffer, buffer_f32);
        var rx = 360 - buffer_read(buffer, buffer_f32);
        var ry = buffer_read(buffer, buffer_f32);
        var rz = buffer_read(buffer, buffer_f32);
        
        var mesh_index = buffer_read(buffer, buffer_s32);
        var texture_index = buffer_read(buffer, buffer_s32);
        
        if (mesh_index == -1) {
            // some special objects, deal with later
            continue;
        }
        
        if (mesh_lookup[mesh_index] == undefined) {
            show_debug_message($"Hey! Mesh with name {mesh_name_lookup[mesh_index]} doesn't exist. You should probably make it exist.");
            continue;
        }
        
        var inst = instance_create_depth(xx, yy, zz, obj_3d_object, {
            rotation_mat: matrix_build(0, 0, 0, rx, ry, rz, 1, 1, 1),
            direction: ry
        });
        
        inst.SetMesh(mesh_lookup[mesh_index]);
        inst.UpdateCollisionPositions();
    }
    
    buffer_delete(buffer);
}