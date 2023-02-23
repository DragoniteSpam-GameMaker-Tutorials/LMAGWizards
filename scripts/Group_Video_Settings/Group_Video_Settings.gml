#macro Video    global.__video_settings__

Video = new VideoSettingsConstructor();

function VideoSettingsConstructor() constructor {
    self.resolution = {
        x: 1366,
        y: 768
    };
    
    self.frame_rate = 60;
    
    self.resolution_scale = {
        x: 1,
        y: 1
    };
    
    self.particle_density = 1;
    
    self.fullscreen = false;
    
    static SetResolution = function(w = self.resolution.x, h = self.resolution.y) {
        self.resolution.x = w;
        self.resolution.y = h;
        
        window_set_size(w, h);
        window_center();
        
        self.Save();
    };
    
    static SetResolutionScale = function(w = self.resolution_scale.x, h = self.resolution_scale.y) {
        self.resolution_scale.x = w;
        self.resolution_scale.y = h;
        
        self.Save();
    };
    
    static SetFullscreen = function(fullscreen = self.fullscreen) {
        self.fullscreen = fullscreen;
        window_set_fullscreen(fullscreen);
        
        self.Save();
    };
    
    static SetFrameRate = function(frame_rate = self.frame_rate) {
        self.frame_rate = frame_rate;
        game_set_speed(frame_rate, gamespeed_fps);
        
        self.Save();
    };
    
    static SetParticleDensity = function(density = self.particle_density) {
        self.particle_density = density;
        
        self.Save();
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
    
    static Save = function() {
        var json = json_stringify(self);
        static save_buffer = buffer_create(1, buffer_fixed, 1);
        
        if (buffer_get_size(save_buffer) < string_byte_length(json)) {
            buffer_resize(save_buffer, string_byte_length(json));
        }
        
        buffer_seek(save_buffer, buffer_seek_start, 0);
        buffer_write(save_buffer, buffer_text, json);
        buffer_save_ext(save_buffer, FILE_VIDEO_SETTINGS, 0, buffer_tell(save_buffer));
    };
}