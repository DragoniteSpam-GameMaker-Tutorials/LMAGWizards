event_inherited();

self.radius = 16;

self.cshape = new ColSphere(new Vector3(0, self.radius, 0), self.radius);
self.cobject = new ColObject(self.cshape, self.id, ECollisionMasks.DEFAULT, ECollisionMasks.DEFAULT);
obj_game.collision.Add(self.cobject);

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
    
    if (below_me != undefined && below_me.reference.motion != undefined) {
        return below_me.reference.motion.Mul(DT);
    }
    
    return new Vector3(0, 0, 0);
};

self.OnCollision = function(displacement_vector) {
};

self.OnSpellHit = function(spell) {
    if (spell.object_index != self.spell_response) return;
    
    //self.state.onspell();
    
    show_debug_message("hit by mind read spell")
};

self.UpdateCollisionPositions = function() {
    var position = self.cobject.shape.position;
    position.x = self.x;
    position.y = self.y;
    position.z = self.z;
    
    obj_game.collision.Remove(self.cobject);
    obj_game.collision.Add(self.cobject);
};
