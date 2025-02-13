#macro Particles global.__particles 

function SparticleSystem() constructor {
    self.systems = {
        test_unlit_effects: new spart_system([256, 600]),
    };
    
    self.types = {
        fire: new spart_type(),
    };
    
    with (self.types.fire) {
        setSprite(spr_particle_main, 0, 1);
        setSize(4, 10, 0, 0, 0, 200);
        setLife(0.25, 0.4);
        setOrientation(0, 360, 150, 0, true);
        setSpeed(120, 160, 0, 0);
        setDirection(0, 1, 0, 30, false);
        setColour(c_orange, 1, c_orange, 1, c_orange, 0.6, c_orange, 0);
        setBlend(true, true);
    }
    
    self.emitters = {
        
    };
    
    static BurstFromEmitter = function(emitter, type, x, y, z, amount) {
        emitter.setRegion(matrix_build(x, y, z, 0, 0, 0, 1, 1, 1), 1, 1, 1, spart_shape_cube, spart_distr_linear, false);
        var n = amount;
        if (n < 1) {
            if (random(1) < n) {
                emitter.burst(type, n, true);
            }
        } else {
            emitter.burst(type, n, true);
        }
    };
    
    static BurstFromEmitterRadius = function(emitter, type, x, y, z, radius, amount) {
        emitter.setRegion(matrix_build(x, y, z, 0, 0, 0, 1, 1, 1), radius, radius, radius, spart_shape_sphere, spart_distr_linear, false);
        var n = amount;
        if (n < 1) {
            if (random(1) < n) {
                emitter.burst(type, n, true);
            }
        } else {
            emitter.burst(type, n, true);
        }
    };
    
    static Render = function() {
        shader_set(sh_spart);
        shader_set_uniform_f(shader_get_uniform(sh_spart, "u_MaterialType"), 0);
        self.systems.test_unlit_effects.draw(game_get_speed(gamespeed_microseconds) / 1000000);
    };
};