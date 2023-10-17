self.lifespan -= DT;

if (self.lifespan <= 0) {
    instance_destroy();
    return;
}

var position = new Vector3(self.x, self.y, self.z);
var ray = new ColRay(position, self.velocity.Normalize());

var caster_mask = self.caster.cobject.mask;
self.caster.cobject.mask = 0;
var raycast_result = obj_game.collision.CheckRay(ray, ECollisionMasks.DEFAULT | ECollisionMasks.SPELL_TARGET);
self.caster.cobject.mask = caster_mask;

if (raycast_result) {
    if (raycast_result.distance <= self.velocity.Magnitude() * DT) {
        raycast_result.shape.object.reference.OnSpellHit(self.id);
        instance_destroy();
        return;
    }
}

self.x += self.velocity.x * DT;
self.y += self.velocity.y * DT;
self.z += self.velocity.z * DT;