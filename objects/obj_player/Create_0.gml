event_inherited();

var player_data = obj_game.meshes.player;
var player_climb_collision = player_data.collision_shapes[array_find_index(player_data.collision_shapes, function(shape) {
    return shape.name == "#ClimbDetection";
})];
    
var original_position = new Vector3(player_climb_collision.position.x, player_climb_collision.position.y, player_climb_collision.position.z);
var climb_shape = new ColSphere(original_position, player_climb_collision.radius);
climb_shape.original_position = original_position.Mul(1);
self.cobject_climb = new ColObject(climb_shape, self.id, ECollisionMasks.NONE, ECollisionMasks.CLIMBABLE);

self.camera_target = player_data.collision_shapes[array_find_index(player_data.collision_shapes, function(shape) {
    return shape.name == "#CameraTarget";
})].position;

self.camera = new Camera(0, 250, 0, 1000, 0, 1000, 0, 1, 0, 60, 16 / 9, 1, 10000);

self.UpdateCamera = function() {
    var player_transform = matrix_build(self.x, self.y, self.z, 0, self.direction, 0, 1, 1, 1);
    var camera_target_transformed = matrix_transform_vertex(player_transform, self.camera_target.x, self.camera_target.y, self.camera_target.z);
    
    self.camera.xto = camera_target_transformed[0];
    self.camera.yto = camera_target_transformed[1];
    self.camera.zto = camera_target_transformed[2];
    
    self.camera.x = self.camera.xto - self.camera.distance * dcos(self.camera.direction) * dcos(self.camera.pitch);
    self.camera.y = self.camera.yto + self.camera.distance * dsin(self.camera.pitch);
    self.camera.z = self.camera.zto + self.camera.distance * dsin(self.camera.direction) * dcos(self.camera.pitch);
};