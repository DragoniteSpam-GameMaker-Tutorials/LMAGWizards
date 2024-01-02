event_inherited();

self.default_collision_mask = ECollisionMasks.DEFAULT;

self.mesh = undefined;
self.cshapes = [];
self.cobjects = [];

self.state = undefined;

self.SetMesh = function(mesh, mask = self.default_collision_mask, group = ECollisionMasks.DEFAULT) {
    self.mesh = mesh;
	
	array_foreach(self.cobjects, function(obj) {
		obj_game.collision.Remove(obj);
	});
	
    self.cshapes = [];
    self.cobjects = [];
    for (var i = 0, n = array_length(mesh.collision_shapes); i < n; i++) {
        var shape_data = mesh.collision_shapes[i];
        var shape_mask = mask;
        var shape_group = group;
       
        // there may be some special collision shapes
        if (string_starts_with(shape_data.name, "#")) {
            switch (shape_data.name) {
                case "#Climb":
                    shape_mask = ECollisionMasks.CLIMBABLE;
                    break;
                case "#ClimbDetection":
                    shape_mask = ECollisionMasks.NONE;
                    shape_group = ECollisionMasks.NONE;
                    break;
                case "#CameraTarget":
                    shape_mask = ECollisionMasks.NONE;
                    shape_group = ECollisionMasks.NONE;
                    break;
                case "#SpellTarget":
                    shape_mask = ECollisionMasks.SPELL_TARGET;
                    shape_group = ECollisionMasks.NONE;
                    break;
                case "#Activation":
                    shape_mask = ECollisionMasks.NONE;
                    shape_group = ECollisionMasks.DEFAULT;
                    break;
            }
        }
        
        var shape = undefined;
        if (is_instanceof(shape_data, PenguinCollisionShapeSphere)) {
            var original_position = new Vector3(shape_data.position.x, shape_data.position.y, shape_data.position.z);
            var original_radius = shape_data.radius;
            shape = new ColSphere(original_position.Mul(1), original_radius);
            shape.original_position = original_position;
            shape.original_radius = original_radius;
        }
        if (is_instanceof(shape_data, PenguinCollisionShapeBox)) {
            var original_position = new Vector3(shape_data.position.x, shape_data.position.y, shape_data.position.z);
            var original_size = new Vector3(shape_data.scale.x, shape_data.scale.y, shape_data.scale.z);
            var original_orientation = [
                /*shape_data.orientation.x.x, shape_data.orientation.x.y, shape_data.orientation.x.z, 0,
                shape_data.orientation.y.x, shape_data.orientation.y.y, shape_data.orientation.y.z, 0,
                shape_data.orientation.z.x, shape_data.orientation.z.y, shape_data.orientation.z.z, 0,*/
				shape_data.orientation.x.x, shape_data.orientation.y.x, shape_data.orientation.z.x, 0,
                shape_data.orientation.x.y, shape_data.orientation.y.y, shape_data.orientation.z.y, 0,
                shape_data.orientation.x.z, shape_data.orientation.y.z, shape_data.orientation.z.z, 0,
				0, 0, 0, 1
            ];
            shape = new ColOBB(original_position.Mul(1), original_size.Mul(1), variable_clone(original_orientation));
            shape.original_position = original_position;
            shape.original_size = original_size;
            shape.original_orientation = original_orientation;
        }
        // if you want to add capsules you can, but it'll probably be a pain
        
        if (shape != undefined) {
            var object = new ColObject(shape, self.id, shape_mask, shape_group);
            obj_game.collision.Add(object);
            array_push(self.cshapes, shape);
            array_push(self.cobjects, object);
        }
    }
};

self.UpdateCollisionPositions = function() {
    var object_transform = matrix_multiply(self.rotation_mat, matrix_build(self.x, self.y, self.z, 0, 0, 0, 1, 1, 1));
    
    for (var i = 0, n = array_length(self.cobjects); i < n; i++) {
        var object = self.cobjects[i];
        var shape = object.shape;
        if (is_instanceof(shape, ColOBB)) {
            var new_size = shape.original_size;
			var op = shape.original_position;
            
            var transform = matrix_multiply(shape.original_orientation, matrix_build(op.x, op.y, op.z, 0, 0, 0, 1, 1, 1));
            transform = matrix_multiply(transform, object_transform);
            
            var new_position = new Vector3(transform[12], transform[13], transform[14]);
			transform[12] = 0;
			transform[13] = 0;
			transform[14] = 0;
            shape.Set(new_position, new_size, transform);
        } else {
            // sphere
            var new_position = shape.original_position.Add(new Vector3(self.x, self.y, self.z));
            shape.Set(new_position);
        }
        obj_game.collision.Remove(object);
        obj_game.collision.Add(object);
    }
};

self.OnCollection = function() {
	GameState.AddCurrency(1);
	show_debug_message($"You have {GameState.currency} money");
};