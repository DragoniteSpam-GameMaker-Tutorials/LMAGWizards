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
    
    self.fullscreen = false;
    
    self.particle_density = 1;
    
    static SetResolution = function(w, h) {
        self.resolution.x = w;
        self.resolution.y = h;
        
        window_set_size(w, h);
        window_center();
    };
}