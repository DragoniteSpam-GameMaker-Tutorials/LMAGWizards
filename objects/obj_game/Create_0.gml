vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_texcoord();
vertex_format_add_colour();
self.vertex_format = vertex_format_end();

self.meshes = penguin_load("meshes.derg", self.vertex_format);

self.camera = new Camera(0, 250, 0, 1000, 0, 1000, 0, 1, 0, 60, 16 / 9, 1, 10000);

self.gbuff_position = -1;
self.gbuff_material = -1;

application_surface_draw_enable(false);

try {
    var buffer = buffer_load(FILE_VIDEO_SETTINGS);
    var json = buffer_read(buffer, buffer_text);
    buffer_delete(buffer);
    
    var loaded_settings = json_parse(json);
    var video_settings_type = static_get(Video);
    static_set(loaded_settings, video_settings_type);
    
    loaded_settings.SetResolution();
    loaded_settings.SetFullscreen();
    loaded_settings.SetFrameRate();
    
    Video = loaded_settings;
} catch (e) {
    show_debug_message("Couldn't load the video settings for some reason: {0}", e.message);
}

try {
    var buffer = buffer_load(FILE_AUDIO_SETTINGS);
    var json = buffer_read(buffer, buffer_text);
    buffer_delete(buffer);
    
    var loaded_settings = json_parse(json);
    var video_settings_type = static_get(Audio);
    static_set(loaded_settings, video_settings_type);
    
    Audio = loaded_settings;
    Audio.Apply();
} catch (e) {
    show_debug_message("Couldn't load the audio settings for some reason: {0}", e.message);
}

instance_create_depth(0, 0, 0, obj_player);