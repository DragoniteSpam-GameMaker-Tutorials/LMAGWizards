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
    self.distance = 160;
    
    self.camera = camera_create();
    
    self.UpdateFree = function() {
        var dx = 0;
        var dy = 0;
        var dz = 0;
        
        var spd = 4;
        
        if (keyboard_check(ord("W"))) {
            dx += dcos(self.direction) * dcos(self.pitch);
            dy -= dsin(self.pitch);
            dz -= dsin(self.direction) * dcos(self.pitch);
        }
        
        if (keyboard_check(ord("S"))) {
            dx -= dcos(self.direction) * dcos(self.pitch);
            dy += dsin(self.pitch);
            dz += dsin(self.direction) * dcos(self.pitch);
        }
        
        if (keyboard_check(ord("D"))) {
            dx -= dsin(self.direction) * dcos(self.pitch);
            dz -= dcos(self.direction) * dcos(self.pitch);
        }
        
        if (keyboard_check(ord("A"))) {
            dx += dsin(self.direction) * dcos(self.pitch);
            dz += dcos(self.direction) * dcos(self.pitch);
        }
        
        if (mouse_check_button(mb_middle)) {
            var mx = window_mouse_get_x() - window_get_width() / 2;
            var my = window_mouse_get_y() - window_get_height() / 2;
            self.direction += mx / 10;
            self.pitch = clamp(self.pitch + my / 10, -80, 80);
            window_mouse_set(window_get_width() / 2, window_get_height() / 2);
        }
        
        self.x += dx * spd;
        self.y += dy * spd;
        self.z += dz * spd;
        
        self.xto = self.x + dcos(self.direction) * dcos(self.pitch);
        self.yto = self.y - dsin(self.pitch);
        self.zto = self.z - dsin(self.direction) * dcos(self.pitch);
    };
    
    self.Apply = function() {
        var view_mat = matrix_build_lookat(self.x, self.y, self.z, self.xto, self.yto, self.zto, self.xup, self.yup, self.zup);
        var proj_mat = matrix_build_projection_perspective_fov(-self.fov, -self.aspect, self.znear, self.zfar);
        camera_set_view_mat(self.camera, view_mat);
        camera_set_proj_mat(self.camera, proj_mat);
        camera_apply(self.camera);
    };
    
    self.GetViewMat = function() {
        return camera_get_view_mat(self.camera);
    };
    
    self.GetProjMat = function() {
        return camera_get_proj_mat(self.camera);
    };
    
    self.DrawSkybox = function(skybox_model) {
        gpu_set_ztestenable(false);
        gpu_set_zwriteenable(false);
        material_set_material_type(EMaterialTypes.UNLIT);
        matrix_set(matrix_world, matrix_build(self.x, self.y, self.z, 0, 0, 0, 1, 1, 1));
        skybox_model.Render();
        gpu_set_ztestenable(true);
        gpu_set_zwriteenable(true);
    };
}