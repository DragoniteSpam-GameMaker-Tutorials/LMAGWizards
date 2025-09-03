function get_nearest_waypoint(ref, x, y, z) {
    y += 4;
    
    var nearest = undefined;
    var nearest_distance = infinity;
    
    for (var i = 0; i < array_length(obj_game.map.aquila_nodes); i++) {
        var node_position = obj_game.map.aquila_nodes[i].position;
        var aquila_node = obj_game.map.aquila_nodes[i].aquila_node;
        var node_distance = point_distance_3d(node_position.x, node_position.y, node_position.z, x, y, z);
        
        // you might later want to optimize this by making ray and ray_obj
        // static and resetting their values every time theyre used
        if (nearest == undefined) {
            if (get_line_of_sight(ref, x, y, z, node_position.x, node_position.y, node_position.z)) {
                nearest = aquila_node;
                nearest_distance = node_distance;
            }
        } else {
            if (node_distance < nearest_distance) {
                if (get_line_of_sight(ref, x, y, z, node_position.x, node_position.y, node_position.z)) {
                    nearest = aquila_node;
                    nearest_distance = node_distance;
                }
            }
        }
    }
    
    return nearest;
}

function get_line_of_sight(ref, x1, y1, z1, x2, y2, z2) {
    var start = new Vector3(x1, y1, z1);
    var target = new Vector3(x2, y2, z2);
    var ray = new ColLine(start, target);
    var ray_obj = new ColObject(ray, ref, ECollisionMasks.INHIBIT_PATHFINDING, ECollisionMasks.INHIBIT_PATHFINDING);
    
    return obj_game.collision.CheckObject(ray_obj, true) == undefined;
}