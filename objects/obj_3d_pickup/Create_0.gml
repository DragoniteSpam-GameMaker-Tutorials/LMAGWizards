event_inherited();

self.inheritedSetMesh = self.SetMesh;
self.SetMesh = function(mesh) {
	self.inheritedSetMesh(mesh, ECollisionMasks.PICKUP, ECollisionMasks.PICKUP);
};

self.UpdateCollisionPositions();