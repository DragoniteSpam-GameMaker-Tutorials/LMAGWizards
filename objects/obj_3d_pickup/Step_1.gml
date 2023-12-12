if (self.is_moving) {
    self.yspeed -= 100 * DT;
    
    if (self.parent != undefined) {
        array_foreach(self.parent.cobjects, function(obj) {
            obj_game.collision.Remove(obj);
        });
    }
    
    var ray_hit = obj_game.collision.CheckRay(new ColRay(new Vector3(self.x, self.y, self.z), new Vector3(self.xspeed, 0, self.zspeed).Normalize()), ECollisionMasks.DEFAULT);
    
    if (ray_hit != undefined && ray_hit.distance <= point_distance(self.xspeed * DT, self.zspeed * DT, 0, 0)) {
        self.x = ray_hit.point.x;
        self.z = ray_hit.point.z;
        self.xspeed = 0;
        self.zspeed = 0;
    } else {
        self.x += self.xspeed * DT;
        self.z += self.zspeed * DT;
    }
    
    ray_hit = obj_game.collision.CheckRay(new ColRay(new Vector3(self.x, self.y, self.z), new Vector3(0, sign(self.yspeed), 0)), ECollisionMasks.DEFAULT);
    
    if (ray_hit != undefined && ray_hit.distance <= self.yspeed * DT) {
        self.y = ray_hit.point.y;
        self.yspeed = 0;
        self.is_moving = false;
    } else {
        self.y += self.yspeed * DT;
    }
    
    if (self.y <= 0) {
        self.y = 0;
        self.yspeed = 0;
        self.is_moving = false;
    }
    
    if (self.parent != undefined) {
        array_foreach(self.parent.cobjects, function(obj) {
            obj_game.collision.Add(obj);
        });
    }
    
    self.UpdateCollisionPositions();
}