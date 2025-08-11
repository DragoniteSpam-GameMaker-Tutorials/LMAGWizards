function get_nearest_waypoint(x, y, z) {
    y += 4;
    
    var start = new Vector3(x, y, z);
    var nearest = undefined;
    var nearest_distance = infinity;
    
    for (var i = 0; i < array_length(obj_game.map.aquila_nodes); i++) {
        var node_position = obj_game.map.aquila_nodes[i].position;
        var aquila_node = obj_game.map.aquila_nodes[i].aquila_node;
        var node_distance = point_distance_3d(node_position.x, node_position.y, node_position.z, x, y, z);
        
        // you might later want to optimize this by making ray and ray_obj
        // static and resetting their values every time theyre used
        if (nearest == undefined) {
            var ray = new ColLine(start, node_position);
            var ray_obj = new ColObject(ray, self);
            var raycast_result = obj_game.collision.CheckObject(ray_obj);
            if (raycast_result == undefined) {
                nearest = aquila_node;
                nearest_distance = node_distance;
            }
        } else {
            if (node_distance < nearest_distance) {
                var ray = new ColLine(start, node_position);
                var ray_obj = new ColObject(ray, self);
                var raycast_result = obj_game.collision.CheckObject(ray_obj);
                if (raycast_result == undefined) {
                    nearest = aquila_node;
                    nearest_distance = node_distance;
                }
            }
        }
    }
    
    return nearest;
}