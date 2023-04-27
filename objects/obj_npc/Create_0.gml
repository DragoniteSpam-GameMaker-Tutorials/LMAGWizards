event_inherited();

self.cshape = new ColSphere(new Vector3(0, 16, 0), 16);
self.cobject = new ColObject(self.cshape, self.id, 1, 1);

self.IsGrounded = function() {
    self.cshape.position.y -= 1;
    var grounded = obj_game.collision.CheckObject(self.cobject);
    self.cshape.position.y += 1;
    return grounded || self.y <= 0;
};