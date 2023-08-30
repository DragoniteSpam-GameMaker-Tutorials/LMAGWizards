if (self.mesh != undefined) {
    // debug draw
    if (keyboard_check(vk_f1)) {
        var object_transform = new Matrix4(self.rotation_mat)
            .Mul(new Vector3(self.x, self.y, self.z).GetTranslationMatrix());
        
        for (var i = 0, n = array_length(self.cobjects); i < n; i++) {
            var object = self.cobjects[i];
            var shape = object.shape;
            if (is_instanceof(shape, ColOBB)) {
                var transform = new Matrix4(matrix_build(0, 0, 0, 0, 0, 0, shape.original_size.x, shape.original_size.y, shape.original_size.z))
                    .Mul(shape.original_orientation.GetRotationMatrix())
                    .Mul(shape.original_position.GetTranslationMatrix())
                    .Mul(object_transform);
                
                matrix_set(matrix_world, transform.linear_array);
                vertex_submit(obj_game.debug_cube, pr_trianglelist, -1);
                matrix_set(matrix_world, matrix_build_identity());
            } else if (is_instanceof(shape, ColSphere)) {
                matrix_set(matrix_world, matrix_build(self.x + shape.original_position.x, self.y + shape.original_position.y, self.z + shape.original_position.z, 0, 0, 0, shape.original_radius, shape.original_radius, shape.original_radius));
                vertex_submit(obj_game.debug_sphere, pr_trianglelist, -1);
                matrix_set(matrix_world, matrix_build_identity());
            }
        }
    } else {
        var position_mat = matrix_build(self.x, self.y, self.z, 0, 0, 0, 1, 1, 1);
        var transform_mat = matrix_multiply(self.rotation_mat, position_mat);
        matrix_set(matrix_world, transform_mat);
        self.mesh.Render();
        matrix_set(matrix_world, matrix_build_identity());
    }
}