var position = new Vector3(self.x, self.y, self.z);
var ray = new ColRay(position, self.velocity.Normalize());

var raycast_result = obj_game.collision.CheckRay(ray);
if (raycast_result) {
    if (raycast_result.distance <= self.velocity.Magnitude() * DT) {
        instance_destroy();
    }
} else {
    self.x += self.velocity.x * DT;
    self.y += self.velocity.y * DT;
    self.z += self.velocity.z * DT;
}

self.lifespan -= DT;

if (self.lifespan <= 0) {
    instance_destroy();
}