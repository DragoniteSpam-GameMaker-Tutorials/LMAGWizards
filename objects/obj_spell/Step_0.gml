var position = new Vector3(self.x, self.y, self.z);
var ray = new ColRay(position, self.speed.Normalize());
var raycast_result = obj_game.collision.CheckRay(ray);

if (raycast_result) {
    if (raycast_result.distance <= self.speed.Magnitude() * DT) {
        instance_destroy();
        show_debug_message("bye");
    } else {
        self.x += self.speed.x * DT;
        self.y += self.speed.y * DT;
        self.z += self.speed.z * DT;
    }
}