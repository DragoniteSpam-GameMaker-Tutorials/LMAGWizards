function UnityMapImport(filename, meshes) constructor {
    static header_value = "derg map";
    
    static load_objects = function(buffer, meshes) {
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
            
            var special_index = buffer_read(buffer, buffer_s32);
            
            if (mesh_index == -1) {
                // some special objects, deal with later
                continue;
            }
            
            if (mesh_lookup[mesh_index] == undefined) {
                show_debug_message($"Hey! Mesh with name {mesh_name_lookup[mesh_index]} doesn't exist. You should probably make it exist.");
                continue;
            }
            
            var type = obj_3d_object;
            var params = {
                rotation_mat: matrix_build(0, 0, 0, rx, ry, rz, 1, 1, 1),
                direction: ry
            };
            
            switch (special_index) {
                case EWizardSchoolObjects.BLOCK:
                    type = obj_3d_spell_block;
                    break;
                case EWizardSchoolObjects.BOULDER:
                    type = obj_3d_spell_boulder;
                    break;
                case EWizardSchoolObjects.BARREL:
                    type = obj_3d_spell_barrel;
                    break;
                case EWizardSchoolObjects.BUTTON:
                    type = obj_3d_spell_push_button;
                    params.on_activation = buffer_read(buffer, buffer_string);
                    break;
                case EWizardSchoolObjects.SWITCH:
                    type = obj_3d_spell_toggle_switch;
                    params.on_activation = buffer_read(buffer, buffer_string);
                    params.on_deactivation = buffer_read(buffer, buffer_string);
                    params.start_active = buffer_read(buffer, buffer_bool);
                    break;
                
                case EWizardSchoolObjects.CHEST:
                    type = obj_3d_spell_treasure_chest;
                    params.can_be_unlocked = buffer_read(buffer, buffer_bool);
                    //params.contents = array_create(buffer_read(buffer, buffer_s32));
                    var contents = array_create(buffer_read(buffer, buffer_s32));
                    
                    //repeat (array_length(params.contents)) {
                    repeat (array_length(contents)) {
                        // tba
                        buffer_read(buffer, buffer_string);
                    }
                    break;
                case EWizardSchoolObjects.DOOR:
                    type = obj_3d_spell_door;
                    params.can_be_unlocked = buffer_read(buffer, buffer_bool);
                    break;
                case EWizardSchoolObjects.SECRET_WALL:
                    type = obj_3d_spell_secret_wall;
                    break;
                case EWizardSchoolObjects.BOUNCE_PAD:
                    type = obj_3d_spell_bounce_pad;
                    var tx = buffer_read(buffer, buffer_f32);
                    var ty = buffer_read(buffer, buffer_f32);
                    var tz = buffer_read(buffer, buffer_f32);
                    var ax = buffer_read(buffer, buffer_f32);
                    var ay = buffer_read(buffer, buffer_f32);
                    var az = buffer_read(buffer, buffer_f32);
                    params.target = new Vector3(tx, ty, tz);
                    params.apex = new Vector3(ax, ay, az);
                    break;
                case EWizardSchoolObjects.FLOWER:
                    type = obj_3d_spell_flower;
                    break;
                case EWizardSchoolObjects.HOURGLASS:
                    type = obj_3d_spell_hourglass;
                    break;
            }
            
            var inst = instance_create_depth(xx, yy, zz, type, params);
            
            inst.SetMesh(mesh_lookup[mesh_index]);
            inst.UpdateCollisionPositions();
        }
    };
    
    static load_pathfinding = function(buffer) {
        var node_count = buffer_read(buffer, buffer_s32);
        var node_map = { };
        var aquila = new Aquila();
        for (var i = 0; i < node_count; i++) {
            var node_id = buffer_read(buffer, buffer_s32);
            var node_x = buffer_read(buffer, buffer_f32);
            var node_y = buffer_read(buffer, buffer_f32);
            var node_z = buffer_read(buffer, buffer_f32);
            var node_position = new Vector3(node_x, node_y, node_z);
            var connection_count = buffer_read(buffer, buffer_s32);
            var connections = array_create(connection_count);
            for (var j = 0; j < connection_count; j++) {
                connections[j] = buffer_read(buffer, buffer_s32);
            }
            
            node_map[$ string(node_id)] = {
                id: node_id,
                position: node_position,
                connections: connections,
                aquila_node: aquila.AddNode(node_position)
            };
        }
        
        // yes you can use struct_foreach and array_map for this, but the code
        // would look hideous
        var keys = struct_get_names(node_map);
        var nodes = array_create(array_length(keys));
        for (var i = 0, n = array_length(keys); i < n; i++) {
            var node = node_map[$ keys[i]];
            for (var j = 0, n2 = array_length(node.connections); j < n2; j++) {
                node.connections[j] = node_map[$ string(node.connections[j])];
                var other_node = node.connections[j];
                node.aquila_node.Connect(other_node.aquila_node, node.position.DistanceTo(other_node.position));
            }
            nodes[i] = node;
        }
        
        return {
            aquila, nodes
        }
    };
    
    self.aquila = undefined;
    self.aquila_nodes = [];
    
    var buffer = buffer_load(filename);
    var header = buffer_read(buffer, buffer_string);
    
    if (header != header_value) {
        buffer_delete(buffer);
        return;
    }
    
    var version = buffer_read(buffer, buffer_s32);
    
    while (buffer_tell(buffer) < buffer_get_size(buffer)) {
        var type = buffer_read(buffer, buffer_string);
        
        switch (type) {
            case "OBJECTS":
                load_objects(buffer, meshes);
                break;
            case "PATHFINDING":
                var pathfinding = load_pathfinding(buffer);
                self.aquila = pathfinding.aquila;
                self.aquila_nodes = pathfinding.nodes;
                break;
            default:
                show_debug_message($"no reader function recognized: {type}");
                break;
        }
    }
    
    buffer_delete(buffer);
}

enum EWizardSchoolObjects {
    NONE,

    BLOCK,
    BOULDER,
    BARREL,
    BUTTON,
    SWITCH,

    CHEST,
    DOOR,
    SECRET_WALL,
    
    BOUNCE_PAD,
	FLOWER,
	HOURGLASS
}