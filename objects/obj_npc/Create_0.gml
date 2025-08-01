event_inherited();

self.radius = 16;

self.cshape = new ColSphere(new Vector3(0, self.radius, 0), self.radius);
self.cobject = new ColObject(self.cshape, self.id, ECollisionMasks.DEFAULT, ECollisionMasks.DEFAULT);
obj_game.collision.Add(self.cobject);

self.pathfinding = undefined;

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
    
    array_push(obj_game.thought_bubbles, new ThoughtBubble(self.GetMindReadText(), 10, self));
};

self.UpdateCollisionPositions = function() {
    var position = self.cobject.shape.position;
    position.x = self.x;
    position.y = self.y;
    position.z = self.z;
    
    obj_game.collision.Remove(self.cobject);
    obj_game.collision.Add(self.cobject);
};

self.GetMindReadText = function() {
    return "The quick brown fox jumped over me";
};

self.GetNearestPathfindingWaypoint = function() {
    var choices = obj_game.map.aquila_nodes;
    
    var nearest = undefined;
    var nearest_distance = infinity;
    
    for (var i = 0, n = array_length(choices); i < n; i++) {
        var location = choices[i].position;
        var test_distance = point_distance_3d(self.x, self.y, self.z, location.x, location.y, location.z);
        if (nearest == undefined) {
            nearest = choices[i].aquila_node;
            nearest_distance = test_distance;
        } else {
            if (test_distance < nearest_distance) {
                nearest_distance = test_distance;
                nearest = choices[i].aquila_node;
            }
        }
    }
    
    return nearest;
};