event_inherited();

self.mesh = undefined;
self.cshapes = [];
self.cobjects = [];

self.SetMesh = function(mesh, mask = 1, group = 1) {
    self.mesh = mesh;
    self.cshapes = [];
    self.cobjects = [];
    for (var i = 0, n = array_length(mesh.collision_shapes); i < n; i++) {
        var shape_data = mesh.collision_shapes[i];
        var shape = undefined;
        if (is_instanceof(shape_data, PenguinCollisionShapeSphere)) {
            var original_position = new Vector3(shape_data.position.x, shape_data.position.y, shape_data.position.z);
            var original_radius = shape_data.radius;
            shape = new ColSphere(original_position, original_radius);
            shape.original_position = original_position.Mul(1);
            shape.original_radius = original_radius;
        }
        if (is_instanceof(shape_data, PenguinCollisionShapeBox)) {
            var original_position = new Vector3(shape_data.position.x, shape_data.position.y, shape_data.position.z);
            var original_size = new Vector3(shape_data.scale.x, shape_data.scale.y, shape_data.scale.z).Div(2);
            var original_orientation = new Matrix3(
                shape_data.orientation.x.x, shape_data.orientation.x.y, shape_data.orientation.x.z,
                shape_data.orientation.y.x, shape_data.orientation.y.y, shape_data.orientation.y.z,
                shape_data.orientation.z.x, shape_data.orientation.z.y, shape_data.orientation.z.z
            );
            shape = new ColOBB(original_position, original_size, original_orientation);
            shape.original_position = original_position.Mul(1);
            shape.original_size = original_size.Mul(1);
            shape.original_orientation = new Matrix3(original_orientation.AsLinearArray());
        }
        // if you want to add capsules you can, but it'll probably be a pain
        
        if (shape != undefined) {
            var object = new ColObject(shape, self.id, mask, group);
            obj_game.collision.Add(object);
            array_push(self.cshapes, shape);
            array_push(self.cobjects, object);
        }
    }
};

self.UpdateCollisionPositions = function() {
    for (var i = 0, n = array_length(self.cobjects); i < n; i++) {
        var object = self.cobjects[i];
        var shape = object.shape;
        shape.position.x = self.x + shape.original_position.x;
        shape.position.y = self.y + shape.original_position.y;
        shape.position.z = self.z + shape.original_position.z;
        obj_game.collision.Remove(object);
        obj_game.collision.Add(object);
    }
};