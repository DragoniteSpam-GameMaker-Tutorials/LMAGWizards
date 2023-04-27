if (self.mesh != undefined) {
    matrix_set(matrix_world, matrix_build(self.x, self.y, self.z, 0, 0, 0, 1, 1, 1));
    self.mesh.Render();
    matrix_set(matrix_world, matrix_build_identity());
}