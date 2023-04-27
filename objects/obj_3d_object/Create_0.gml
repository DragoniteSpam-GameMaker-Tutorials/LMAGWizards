event_inherited();

self.mesh = undefined;
self.cshapes = [];
self.cobjects = [];

self.SetMesh = function(mesh) {
    self.mesh = mesh;
    self.cshapes = [];
    self.cobjects = [];
    for (var i = 0, n = array_length(mesh.collision_shapes); i < n; i++) {
        var shape_data = mesh.collision_shapes[i];
        var shape = undefined;
        if (is_instanceof(shape_data, PenguinCollisionShapeSphere)) {
            shape = new ColSphere(
                new Vector3(shape_data.position.x, shape_data.position.y, shape_data.position.z),
                shape_data.radius
            );
        }
        if (is_instanceof(shape_data, PenguinCollisionShapeBox)) {
            shape = new ColOBB(
                new Vector3(shape_data.position.x, shape_data.position.y, shape_data.position.z),
                new Vector3(shape_data.scale.x, shape_data.scale.y, shape_data.scale.z),
                /*new Matrix3(
                    shape_data.orientation.x.x,
                    shape_data.orientation.x.y,
                    shape_data.orientation.x.z,
                    shape_data.orientation.y.x,
                    shape_data.orientation.y.y,
                    shape_data.orientation.y.z,
                    shape_data.orientation.z.x,
                    shape_data.orientation.z.y,
                    shape_data.orientation.z.z,
                )*/
                new Matrix3(1, 0, 0, 0, 1, 0, 0, 0, 1)
            );
        }
        // if you want to add capsules you can, but it'll probably be a pain
        
        if (shape != undefined) {
            var object = new ColObject(shape, self.id, 1, 1);
            obj_game.collision.Add(object);
            array_push(self.cshapes, shape);
            array_push(self.cobjects, object);
        }
    }
};