var final_dx = 0;
var final_dy = 0;
var final_dz = 0;

self.cobject.shape.position.x = self.x + self.xspeed;
self.cobject.shape.position.y = self.y + 16;
self.cobject.shape.position.z = self.z;

if (!obj_game.collision.CheckObject(self.cobject)) {
    final_dx = self.xspeed;
} else {
    for (var i = 1; i < abs(self.xspeed); i++) {
        self.cobject.shape.position.x = self.x + i * sign(self.xspeed);
        if (obj_game.collision.CheckObject(self.cobject)) {
            final_dx = (i - 1) * sign(self.xspeed);
            break;
        }
    }
}

self.cobject.shape.position.x = self.x;
self.cobject.shape.position.y = self.y + self.yspeed + 16;
self.cobject.shape.position.z = self.z;

if (!obj_game.collision.CheckObject(self.cobject)) {
    final_dy = self.yspeed;
} else {
    for (var i = 1; i < abs(self.yspeed); i++) {
        self.cobject.shape.position.y = self.y + 16 + i * sign(self.yspeed);
        if (obj_game.collision.CheckObject(self.cobject)) {
            final_dy = (i - 1) * sign(self.yspeed);
            break;
        }
    }
}

self.cobject.shape.position.x = self.x;
self.cobject.shape.position.y = self.y + 16;
self.cobject.shape.position.z = self.z + self.zspeed;

if (!obj_game.collision.CheckObject(self.cobject)) {
    final_dz = self.zspeed;
} else {
    for (var i = 1; i < abs(self.zspeed); i++) {
        self.cobject.shape.position.z = self.z + i * sign(self.zspeed);
        if (obj_game.collision.CheckObject(self.cobject)) {
            final_dz = (i - 1) * sign(self.zspeed);
            self.yspeed = 0;
            break;
        }
    }
}

self.x += final_dx;
self.y += final_dy;
self.z += final_dz;

if (self.y < 0) {
    self.y = 0;
}