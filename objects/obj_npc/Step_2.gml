var potential = new Vector3(self.xspeed + self.x, self.yspeed + self.y + 16, self.zspeed + self.z);
//potential = potential.Add(self.CheckMovingObjects());
self.cobject.shape.Set(potential);
var displaced_position = obj_game.collision.DisplaceSphere(self.cobject);

if (displaced_position == undefined) {
    self.cobject.shape.Set(potential);
} else {
    self.cobject.shape.Set(displaced_position);
}

self.x = self.cobject.shape.position.x;
self.y = self.cobject.shape.position.y - 16;
self.z = self.cobject.shape.position.z;

if (self.y < 0) {
    self.y = 0;
}