if (((current_time / 1000) % 10) < 5) {
    self.motion.x = 15;
    self.motion.y = 15;
} else {
    self.motion.x = -15;
    self.motion.y = -15;
}

self.x += self.motion.x * DT;
self.y += self.motion.y * DT;
self.z += self.motion.z * DT;

self.UpdateCollisionPositions();