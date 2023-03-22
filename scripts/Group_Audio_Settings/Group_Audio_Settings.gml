#macro Audio    global.__audio_settings__

Audio = new AudioSettingsConstructor();

function AudioSettingsConstructor() constructor {
    self.volume_main = 1;
    self.volume_music = 1;
    self.volume_fx = 1;
    self.volume_ambient = 1;
    
    static emitter_music = audio_emitter_create();
    static emitter_fx = audio_emitter_create();
    static emitter_ambient = audio_emitter_create();
    
    static SetVolumeMain = function(volume) {
        self.volume_main = volume;
        self.Save();
        self.Apply();
    };
    
    static SetVolumeMusic = function(volume) {
        self.volume_music = volume;
        self.Save();
        self.Apply();
    };
    
    static SetVolumeFX = function(volume) {
        self.volume_fx = volume;
        self.Save();
        self.Apply();
    };
    
    static SetVolumeAmbient = function(volume) {
        self.volume_ambient = volume;
        self.Save();
        self.Apply();
    };
    
    static GetVolumeMain = function(volume) {
        return self.volume_main;
    };
    
    static GetVolumeMusic = function(volume) {
        return self.volume_music;
    };
    
    static GetVolumeFX = function(volume) {
        return self.volume_fx;
    };
    
    static GetVolumeAmbient = function(volume) {
        return self.volume_ambient;
    };
    
    static Apply = function() {
        audio_set_master_gain(emitter_music, self.volume_main * self.volume_music);
        audio_set_master_gain(emitter_fx, self.volume_main * self.volume_music);
        audio_set_master_gain(emitter_ambient, self.volume_main * self.volume_music);
    };
    
    static Save = function() {
        var json = json_stringify(self);
        static save_buffer = buffer_create(1, buffer_fixed, 1);
        
        if (buffer_get_size(save_buffer) < string_byte_length(json)) {
            buffer_resize(save_buffer, string_byte_length(json));
        }
        
        buffer_seek(save_buffer, buffer_seek_start, 0);
        buffer_write(save_buffer, buffer_text, json);
        buffer_save_ext(save_buffer, FILE_AUDIO_SETTINGS, 0, buffer_tell(save_buffer));
    };
}