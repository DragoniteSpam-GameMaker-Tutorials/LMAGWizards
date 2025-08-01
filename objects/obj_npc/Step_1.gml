event_inherited();

if (keyboard_check_pressed(vk_enter)) {
    var start = self.GetNearestPathfindingWaypoint();
    
    var target = obj_game.map.aquila_nodes[irandom(array_length(obj_game.map.aquila_nodes) - 1)].aquila_node;
    
    var path = obj_game.map.aquila.Navigate(start, target);
    self.pathfinding = path.route;
}

if (self.pathfinding == undefined) {
    self.xspeed = 0;
    self.zspeed = 0;
} else {
    var speed_run = 300 * DT;
    var speed_walk = 180 * DT;
    
    var target = self.pathfinding[0].data;
    var dx = target.x - self.x;
    //var dy = target.y - self.y;
    var dz = target.z - self.z;
    
    var dist = point_distance(0, 0, dx, dz);
    
    // if you're right on top of a node, stop
    if (dist <= 0.1) {
        dx = 0;
        dz = 0;
        array_delete(self.pathfinding, 0, 1);
        if (array_length(self.pathfinding) == 0) {
            self.pathfinding = undefined;
        }
    // if you're close to a node, set the speed to the vector in the direction of the node
    } else if (dist <= speed_walk) {
        array_delete(self.pathfinding, 0, 1);
        if (array_length(self.pathfinding) == 0) {
            self.pathfinding = undefined;
        }
    // if you're far from a node, set the speed to a vector of the magnitude of the walk speed
    } else {
        dx /= dist;
        dz /= dist;
        dx *= speed_walk;
        dz *= speed_walk;
    }
    
    self.xspeed = dx;
    self.zspeed = dz;
}