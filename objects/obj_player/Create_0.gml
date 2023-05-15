event_inherited();

self.camera = new Camera(0, 250, 0, 1000, 0, 1000, 0, 1, 0, 60, 16 / 9, 1, 10000);

self.UpdateCamera = function() {
    static player_data = obj_game.meshes.player;
    static camera_target_shape = player_data.collision_shapes[array_find_index(player_data.collision_shapes, function(shape) {
        return shape.name == "#CameraTarget";
    })].position;
    
    var player_transform = matrix_build(self.x, self.y, self.z, 0, self.direction, 0, 1, 1, 1);
    var camera_target_transformed = matrix_transform_vertex(player_transform, camera_target_shape.x, camera_target_shape.y, camera_target_shape.z);
    
    self.camera.xto = camera_target_transformed[0];
    self.camera.yto = camera_target_transformed[1];
    self.camera.zto = camera_target_transformed[2];
    
    self.camera.x = self.camera.xto - self.camera.distance * dcos(self.camera.direction) * dcos(self.camera.pitch);
    self.camera.y = self.camera.yto + self.camera.distance * dsin(self.camera.pitch);
    self.camera.z = self.camera.zto + self.camera.distance * dsin(self.camera.direction) * dcos(self.camera.pitch);
};