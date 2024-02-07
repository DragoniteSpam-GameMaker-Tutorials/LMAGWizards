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
        
        var shape = col_shape_from_penguin(shape_data, mask, group);
        
        if (shape != undefined) {
            var object = new ColObject(shape.shape, self.id, shape.shape_mask, shape.shape_group);
            obj_game.collision.Add(object);
            array_push(self.cshapes, shape.shape);
            array_push(self.cobjects, object);
        }
    }
};

self.UpdateCollisionPositions = function() {
    var object_transform = matrix_multiply(self.rotation_mat, matrix_build(self.x, self.y, self.z, 0, 0, 0, 1, 1, 1));
    
    for (var i = 0, n = array_length(self.cobjects); i < n; i++) {
        col_shape_update_position(self.cobjects[i], object_transform);
    }
};

self.OnCollection = function() {
	GameState.AddCurrency(1);
	show_debug_message($"You have {GameState.currency} money");
};