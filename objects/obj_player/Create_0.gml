event_inherited();

self.camera = new Camera(0, 250, 0, 1000, 0, 1000, 0, 1, 0, 60, 16 / 9, 1, 10000);

self.UpdateCamera = function() {
    self.camera.xto = self.x;
    self.camera.yto = self.y;
    self.camera.zto = self.z;
    
    self.camera.x = self.camera.xto - self.camera.distance * dcos(self.camera.direction) * dcos(self.camera.pitch);
    self.camera.y = self.camera.yto + self.camera.distance * dsin(self.camera.pitch);
    self.camera.z = self.camera.zto + self.camera.distance * dsin(self.camera.direction) * dcos(self.camera.pitch);
};