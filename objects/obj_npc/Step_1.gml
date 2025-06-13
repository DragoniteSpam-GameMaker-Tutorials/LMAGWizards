event_inherited();

if (keyboard_check_pressed(vk_enter)) {
    self.pathfinding = [
        self.GetNearestPathfindingWaypoint()
    ];
}

if (self.pathfinding != undefined) {
    var speed_run = 300 * DT;
    var speed_walk = 180 * DT;
    
    var target = self.pathfinding[0].data;
    var dx = target.x - self.x;
    //var dy = target.y - self.y;
    var dz = target.z - self.z;
    
    var dist = point_distance(0, 0, dx, dz);
    
    if (dist <= speed_walk) {
        
    } else {
        dx /= dist;
        dz /= dist;
        dx *= speed_walk;
        dz *= speed_walk;
    }
    
    self.xspeed = dx;
    self.zspeed = dz;
}