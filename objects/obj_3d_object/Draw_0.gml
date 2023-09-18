if (self.mesh != undefined) {
    // debug draw
    if (keyboard_check(vk_f1)) {
        var object_transform = matrix_multiply(self.rotation_mat, matrix_multiply(self.offset_mat, matrix_build(self.x, self.y, self.z, 0, 0, 0, 1, 1, 1)));
        
        for (var i = 0, n = array_length(self.cobjects); i < n; i++) {
            var object = self.cobjects[i];
            var shape = object.shape;
			var op = shape.original_position;
            if (is_instanceof(shape, ColOBB)) {
				var os = shape.original_size;
				var transform = matrix_build(0, 0, 0, 0, 0, 0, os.x, os.y, os.z);
		        transform = matrix_multiply(transform, shape.original_orientation);
				transform = matrix_multiply(transform, matrix_build(op.x, op.y, op.z, 0, 0, 0, 1, 1, 1));
		        transform = matrix_multiply(transform, object_transform);
                
                matrix_set(matrix_world, transform);
                vertex_submit(obj_game.debug_cube, pr_trianglelist, -1);
                matrix_set(matrix_world, matrix_build_identity());
            } else if (is_instanceof(shape, ColSphere)) {
                matrix_set(matrix_world, matrix_build(self.x + op.x, self.y + op.y, self.z + op.z, 0, 0, 0, shape.original_radius, shape.original_radius, shape.original_radius));
                vertex_submit(obj_game.debug_sphere, pr_trianglelist, -1);
                matrix_set(matrix_world, matrix_build_identity());
            }
        }
    } else {
        var position_mat = matrix_multiply(self.offset_mat, matrix_build(self.x, self.y, self.z, 0, 0, 0, 1, 1, 1));
        var transform_mat = matrix_multiply(self.rotation_mat, position_mat);
        matrix_set(matrix_world, transform_mat);
        self.mesh.Render();
        matrix_set(matrix_world, matrix_build_identity());
    }
}