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
    
    static GetVolumeMain = function() {
        return self.volume_main;
    };
    
    static GetVolumeMusic = function() {
        return self.volume_music;
    };
    
    static GetVolumeFX = function() {
        return self.volume_fx;
    };
    
    static GetVolumeAmbient = function() {
        return self.volume_ambient;
    };
    
    static Apply = function() {
        audio_emitter_gain(self.emitter_music, self.volume_main * self.volume_music);
        audio_emitter_gain(self.emitter_fx, self.volume_main * self.volume_fx);
        audio_emitter_gain(self.emitter_ambient, self.volume_main * self.volume_ambient);
    };
    
    static PlayFX = function(sound, priority = SOUND_PRIORITY_DEFAULT, gain = 1, pitch = 1) {
        return audio_play_sound_on(self.emitter_fx, sound, false, priority, gain, 0, pitch);
    };
    
    static PlayAmbient = function(sound, loop = false, priority = SOUND_PRIORITY_AMBIENT, gain = 1, pitch = 1) {
        return audio_play_sound_on(self.emitter_embient, sound, loop, priority, gain, 0, pitch);
    };
    
    static PlayBGM = function(sound, gain = 1, pitch = 1) {
        return audio_play_sound_on(self.emitter_music, sound, true, SOUND_PRIORITY_MUSIC, gain, 0, pitch);
    };
    
    static Fade = function(sound, target_volume, milliseconds) {
        audio_sound_gain(sound, target_volume, milliseconds);
    };
    
    static FadeOutAndStop = function(sound, milliseconds) {
        audio_sound_gain(sound, 0, milliseconds);
        call_later(milliseconds / 1000, time_source_units_seconds, method({ sound: sound }, function() {
            audio_stop_sound(self.sound);
        }));
    };
    
    static Stop = function(sound) {
        return audio_stop_sound(sound);
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