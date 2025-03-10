self.xspeed = 0;
self.yspeed = 0;
self.zspeed = 0;

self.z = self.depth;
self.depth = 0;

self.OnSpellHit = function(spell) {
    if (spell.object_index != self.spell_response) return;
    
    // implementation pending...
};

self.motion = undefined;

self.state = undefined;