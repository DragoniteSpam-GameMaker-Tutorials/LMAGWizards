event_inherited();

self.cshape = new ColSphere(new Vector3(0, 16, 0), 16);
self.cobject = new ColObject(self.cshape, self.id, 1, 1);

self.IsGrounded = function() {
    if (self.y <= 0) return true;
    
    self.cshape.position.y -= 1;
    var grounded = obj_game.collision.CheckObject(self.cobject);
    self.cshape.position.y += 1;
    return grounded;
};

self.CheckMovingObjects = function() {
    self.cobject.shape.position.x = self.x;
    self.cobject.shape.position.y = self.y + 16 - 1;
    self.cobject.shape.position.z = self.z;
    
    var old_group = self.cobject.group;
    self.cobject.group = ECollisionMasks.MOVING;
    var below_me = obj_game.collision.CheckObject(self.cobject);
    self.cobject.group = old_group;
    
    if (below_me != undefined) {
        return below_me.reference.motion;
    }
    
    return new Vector3(0, 0, 0);
};