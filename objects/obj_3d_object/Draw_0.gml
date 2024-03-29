if (self.mesh != undefined) {
    // debug draw
    if (keyboard_check(vk_f1)) {
        var object_transform = matrix_multiply(self.rotation_mat, matrix_build(self.x, self.y, self.z, 0, 0, 0, 1, 1, 1));
        
        for (var i = 0, n = array_length(self.cobjects); i < n; i++) {
            var object = self.cobjects[i];
            col_object_debug_draw(object, object_transform);
        }
    } else {
        var position_mat = matrix_build(self.x, self.y, self.z, 0, 0, 0, 1, 1, 1);
        var transform_mat = matrix_multiply(self.rotation_mat, position_mat);
        matrix_set(matrix_world, transform_mat);
        self.mesh.Render();
        matrix_set(matrix_world, matrix_build_identity());
    }
}