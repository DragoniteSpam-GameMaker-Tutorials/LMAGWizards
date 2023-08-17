vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_texcoord();
vertex_format_add_colour();
self.vertex_format = vertex_format_end();

self.meshes = penguin_load("meshes.derg", self.vertex_format);

self.camera = new Camera(0, 250, 0, 1000, 0, 1000, 0, 1, 0, 60, 16 / 9, 1, 10000);
self.active_camera = self.camera;

input_mouse_coord_space_set(INPUT_COORD_SPACE.GUI);
input_cursor_speed_set(12);
input_mouse_capture_set(true);

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

var spatial_hash = new ColWorldSpatialHash(100);
self.collision = new ColWorld(spatial_hash);

var test_mover = instance_create_depth(100, 0, 100, obj_moving);
test_mover.SetMesh(self.meshes.block_singular);
test_mover.UpdateCollisionPositions();

var test_block = instance_create_depth(300, 0, 100, obj_3d_object);
test_block.SetMesh(self.meshes.block_singular);
test_block.UpdateCollisionPositions();



var test = instance_create_depth(400, 0, 400, obj_3d_object);
test.SetMesh(self.meshes.slope);
test.UpdateCollisionPositions();

var test = instance_create_depth(480, -32, 400, obj_3d_object);
test.SetMesh(self.meshes.bridge);
test.UpdateCollisionPositions();


enum ECollisionMasks {
    NONE                    = 0b0000,
    DEFAULT                 = 0b0001,
    CLIMBABLE               = 0b0010,
    MOVING                  = 0b0100
}