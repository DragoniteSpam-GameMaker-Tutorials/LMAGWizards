if (((current_time / 1000) % 10) < 5) {
    self.motion.y = 0.25;
} else {
    self.motion.y = -0.25;
}

self.x += self.motion.x;
self.y += self.motion.y;
self.z += self.motion.z;

self.UpdateCollisionPositions();