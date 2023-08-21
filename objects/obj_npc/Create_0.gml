event_inherited();

self.radius = 16;

self.cshape = new ColSphere(new Vector3(0, self.radius, 0), self.radius);
self.cobject = new ColObject(self.cshape, self.id, 1, 1);

self.IsGrounded = function() {
    if (self.y <= 0) return true;
    
    self.cshape.position.y -= 1;
    var grounded = obj_game.collision.CheckObject(self.cobject);
    self.cshape.position.y += 1;
    return grounded;
};

self.CheckMovingObjects = function() {
    self.cobject.shape.Set(new Vector3(self.x, self.y + self.radius - 1, self.z));
    
    var old_group = self.cobject.group;
    self.cobject.group = ECollisionMasks.MOVING;
    var below_me = obj_game.collision.CheckObject(self.cobject);
    self.cobject.group = old_group;
    
    if (below_me != undefined) {
        return below_me.reference.motion.Mul(DT);
    }
    
    return new Vector3(0, 0, 0);
};