var final_dx = 0;
var final_dy = 0;
var final_dz = 0;

var potential = new Vector3(self.xspeed, self.yspeed, self.zspeed);

potential = potential.Add(self.CheckMovingObjects());

// tried generalizing this, didnt work out too well, would not recommend
self.cobject.shape.position.x = self.x + potential.x;
self.cobject.shape.position.y = self.y + 16;
self.cobject.shape.position.z = self.z;

if (!obj_game.collision.CheckObject(self.cobject)) {
    final_dx = potential.x;
} else {
    for (var i = 1; i < abs(potential.x); i++) {
        self.cobject.shape.position.x = self.x + i * sign(potential.x);
        if (obj_game.collision.CheckObject(self.cobject)) {
            final_dx = (i - 1) * sign(potential.x);
            break;
        }
    }
}

self.cobject.shape.position.x = self.x;
self.cobject.shape.position.y = self.y + potential.y + 16;
self.cobject.shape.position.z = self.z;

if (!obj_game.collision.CheckObject(self.cobject)) {
    final_dy = potential.y;
} else {
    for (var i = 1; i < abs(potential.y); i++) {
        self.cobject.shape.position.y = self.y + 16 + i * sign(potential.y);
        if (obj_game.collision.CheckObject(self.cobject)) {
            final_dy = (i - 1) * sign(potential.y);
            self.yspeed = 0;
            break;
        }
    }
}

self.cobject.shape.position.x = self.x;
self.cobject.shape.position.y = self.y + 16;
self.cobject.shape.position.z = self.z + potential.z;

if (!obj_game.collision.CheckObject(self.cobject)) {
    final_dz = potential.z;
} else {
    for (var i = 1; i < abs(potential.z); i++) {
        self.cobject.shape.position.z = self.z + i * sign(potential.z);
        if (obj_game.collision.CheckObject(self.cobject)) {
            final_dz = (i - 1) * sign(potential.z);
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