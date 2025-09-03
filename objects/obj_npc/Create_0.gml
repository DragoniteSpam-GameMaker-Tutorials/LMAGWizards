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
        self.state.change("navigation");
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
    
    self.state.change("navigation");
};

self.NavigationCancel = function() {
    self.xspeed = 0;
    self.zspeed = 0;
};

self.NavigationAction = function() {
    var speed_run = 300 * DT;
    var speed_walk = 180 * DT;
    
    var target = self.pathfinding[0].data;
    var dx = target.x - self.x;
    //var dy = target.y - self.y;
    var dz = target.z - self.z;
    
    var dist = point_distance(0, 0, dx, dz);
    
    // if you're close to a node, set the speed to the vector in the direction of the node
    if (dist <= speed_walk) {
        // if you're right on top of a node, stop
        if (dist <= 0.1) {
            dx = 0;
            dz = 0;
        }
        array_delete(self.pathfinding, 0, 1);
        
        // a possible improvement (not yet working)
        /*
        for (var i = 1, n = array_length(self.pathfinding); i < n; i++) {
            var node = self.pathfinding[i];
            if (get_line_of_sight(self, self.x, self.y, self.z, node.x, node.y, node.z)) {
                array_delete(self.pathfinding, 0, i);
                show_debug_message("line of sight found")
                break;
            }
        }
        */
        if (array_length(self.pathfinding) == 0) {
            self.pathfinding = undefined;
        }
    // if you're far from a node, set the speed to a vector of the magnitude of the walk speed
    } else {
        dx /= dist;
        dz /= dist;
        dx *= speed_walk;
        dz *= speed_walk;
    }
    
    self.xspeed = dx;
    self.zspeed = dz;
    
    self.direction = point_direction(0, 0, dx, dz);
};

self.SetSprites = function(collection, animation_speed) {
    var angle = (point_direction(self.x, self.z, obj_game.camera.x, obj_game.camera.z) + self.direction) % 360;
    var current_sprite = collection.front;

    if (angle < 45 || angle > 315) {
        // default values
    } else if (angle < 135) {
        current_sprite = collection.side;
    } else if (angle < 225) {
        current_sprite = collection.back;
    } else {
        current_sprite = collection.side;
    }
    
    if (self.sprite_index != current_sprite) {
        self.image_index = 0;
    }
    self.sprite_index = current_sprite;
    self.image_speed = animation_speed;
};

self.idle_walk_time = 0;

self.state = new SnowState("idle")
    .add("idle", {
        enter: function() {
            self.idle_walk_time = max(3, random(self.random_walk_frequency));
        },
        sprites: function() {
            self.SetSprites(CharacterSprites.duck, 0);
        },
        update: function() {
            self.NavigationCancel();
            self.idle_walk_time -= DT;
            if (self.random_walk_allowed) {
                if (self.idle_walk_time <= 0) {
                    self.state.change("walking_random");
                }
            }
        },
    })
    .add("navigation", {
        leave: function() {
            self.xstart = self.x;
            self.ystart = self.y;
            self.zstart = self.z;
        },
        sprites: function() {
            self.SetSprites(CharacterSprites.duck, 1);
        },
        update: function() {
            if (self.pathfinding == undefined) {
                self.state.change("idle");
                return;
            }
            self.NavigationAction();
        }
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
        sprites: function() {
            self.SetSprites(CharacterSprites.duck, 1);
        },
        update: function() {
            if (self.pathfinding == undefined) {
                self.state.change("idle");
                return;
            }
            self.NavigationAction();
        }
    });