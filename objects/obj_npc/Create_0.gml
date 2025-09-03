event_inherited();

self.zstart = self.z;

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

self.NavigateTo = function(x, y, z) {
    if (get_line_of_sight(self, self.x, self.y + 8, self.z, x, y + 8, z)) {
        self.pathfinding = [{
            data: new Vector3(x, y, z)
        }];
        return;
    }
    
    var start = get_nearest_waypoint(self, self.x, self.y, self.z);
    var target = get_nearest_waypoint(self, x, y, z);
    
    if (start == undefined || target == undefined) return;
    
    var path = obj_game.map.aquila.Navigate(start, target);
    
    self.pathfinding = path.route;
    
    array_push(self.pathfinding, {
        data: new Vector3(x, y, z)
    });
};

self.idle_walk_time = 0;

self.state = new SnowState("idle")
    .add("idle", {
        enter: function() {
            self.idle_walk_time = max(3, random(self.random_walk_frequency));
        },
        update: function() {
            self.idle_walk_time -= DT;
            if (self.random_walk_allowed) {
                if (self.idle_walk_time <= 0) {
                    self.state.change("walking_random");
                }
            }
        },
    })
    .add("walking_random", {
        enter: function() {
            var s = self.random_walk_range / 2;
            var target_x = self.xstart + random_range(-s, s);
            var target_z = self.zstart + random_range(-s, s);
            if (get_line_of_sight(self, self.x, self.y + 8, self.z, target_x, self.y + 8, target_z)) {
                self.pathfinding = [
                    { data: new Vector3(target_x, self.y, target_z) }
                ];
            } else {
                self.state.change("idle");
            }
        },
        update: function() {
            if (self.pathfinding == undefined) {
                self.state.change("idle");
            }
        }
    });