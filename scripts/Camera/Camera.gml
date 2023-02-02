function Camera(x, y, z, xto, yto, zto, xup, yup, zup, fov, aspect, znear, zfar) constructor {
    self.x = x;
    self.y = y;
    self.z = z;
    self.xto = xto;
    self.yto = yto;
    self.zto = zto;
    self.xup = xup;
    self.yup = yup;
    self.zup = zup;
    
    self.fov = fov;
    self.aspect = aspect;
    self.znear = znear;
    self.zfar = zfar;
    
    self.pitch = 0;
    self.direction = 0;
    
    self.camera = camera_create();
    
    self.Apply = function() {
        var view_mat = matrix_build_lookat(self.x, self.y, self.z, self.xto, self.yto, self.zto, self.xup, self.yup, self.zup);
        var proj_mat = matrix_build_projection_perspective_fov(-self.fov, -self.aspect, self.znear, self.zfar);
        camera_set_view_mat(self.camera, view_mat);
        camera_set_proj_mat(self.camera, proj_mat);
        camera_apply(self.camera);
    };
}