var potential = new Vector3(self.xspeed + self.x, self.yspeed + self.y + self.radius, self.zspeed + self.z);
potential = potential.Add(self.CheckMovingObjects());
self.cobject.shape.Set(potential);
var displaced_position = obj_game.collision.DisplaceSphere(self.cobject);

if (displaced_position == undefined) {
    self.cobject.shape.Set(potential);
} else {
    self.cobject.shape.Set(displaced_position);
}

self.x = self.cobject.shape.position.x;
self.y = self.cobject.shape.position.y - self.radius;
self.z = self.cobject.shape.position.z;

// if you're going up and hit something, set yspeed to 0 so that you don't
// get stuck momentarily to whatever you hit
if (self.cobject.shape.position.y < potential.y && self.yspeed > 0) {
    self.yspeed = 0;
}

if (self.y < 0) {
    self.y = 0;
}