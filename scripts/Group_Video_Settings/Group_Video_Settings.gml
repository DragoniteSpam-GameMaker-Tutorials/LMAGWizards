#macro Video    global.__video_settings__

Video = new VideoSettingsConstructor();

function VideoSettingsConstructor() constructor {
    self.resolution = {
        x: 1366,
        y: 768
    };
    
    self.frame_rate = 60;
    
    self.resolution_scale = {
        x: 0.75,
        y: 0.75
    };
    
    self.particle_density = 1;
    
    self.fullscreen = false;
    
    static SetResolution = function(w, h) {
        self.resolution.x = w;
        self.resolution.y = h;
        
        window_set_size(w, h);
        window_center();
    };
    
    static SetResolutionScale = function(w, h) {
        self.resolution_scale.x = w;
        self.resolution_scale.y = h;
    };
    
    static SetFullscreen = function(fullscreen) {
        self.fullscreen = fullscreen;
        window_set_fullscreen(fullscreen);
    };
    
    static SetFrameRate = function(frame_rate) {
        self.frame_rate = frame_rate;
        game_set_speed(frame_rate, gamespeed_fps);
    };
    
    static SetParticleDensity = function(density) {
        self.particle_density = density;
    };
    
    static GetRenderingResolution = function() {
        return {
            x: self.resolution.x * self.resolution_scale.x,
            y: self.resolution.y * self.resolution_scale.y
        };
    };
    
    static GetFullscreen = function() {
        return window_get_fullscreen();
    };
    
    static GetResolutionScale = function() {
        return {
            x: self.resolution_scale.x,
            y: self.resolution_scale.y
        };
    };
    
    static GetFrameRate = function() {
        return self.frame_rate;
    };
    
    static GetParticleDensity = function() {
        return self.particle_density;
    };
}