Particles = new SparticleSystem();

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_texcoord();
vertex_format_add_colour();
self.vertex_format = vertex_format_end();

self.meshes = penguin_load("meshes.derg", self.vertex_format);

self.camera = new Camera(0, 250, 0, 1000, 0, 1000, 0, 1, 0, 60, 16 / 9, 1, 10000);

input_mouse_coord_space_set(INPUT_COORD_SPACE.GUI);
input_cursor_speed_set(12);
input_mouse_capture_set(true);

self.gbuff_position = -1;
self.gbuff_material = -1;
self.gbuff_normal = -1;

self.time_scale = 1;
self.active_timer_objects = [];

self.thought_bubbles = [];

self.ActivateTimer = function(timer) {
	array_push(self.active_timer_objects, timer);
	self.time_scale = 0.25;
};

self.DeactivateTimer = function(timer) {
	var index = array_get_index(self.active_timer_objects, timer);
	if (index != -1) {
		array_delete(self.active_timer_objects, index, 1);
	}
	if (array_length(self.active_timer_objects) == 0) {
		self.time_scale = 1;
	}
};

application_surface_draw_enable(false);

var buffer = buffer_load("cube.vbuff");
self.debug_cube = vertex_create_buffer_from_buffer(buffer, self.vertex_format);
buffer_delete(buffer);
buffer = buffer_load("sphere.vbuff");
self.debug_sphere = vertex_create_buffer_from_buffer(buffer, self.vertex_format);
buffer_delete(buffer);

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
    buffer = buffer_load(FILE_AUDIO_SETTINGS);
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

var spatial_hash = new ColWorldSpatialHash(100);
var octree = new ColWorldOctree(NewColAABBFromMinMax(new Vector3(-1000, -100, -1000), new Vector3(1000, 1000, 1000)), 3);
self.collision = new ColWorld(octree);

self.map = new UnityMapImport("test.place", self.meshes);

var seesaw = instance_create_depth(100, 0, -300, obj_3d_seesaw);
seesaw.UpdateCollisionPositions();

//var npc = instance_create_depth(-200, 0, -450, obj_npc);

var npc = instance_create_depth(200, 0, -450, obj_npc);
npc.GetMindReadText = function() {
    return "Can someone explain sara's collision code, can someone explain what it does?\n\nfor I followed her video exactly, and it simply won't work, just because!";
};

instance_create_depth(0, 0, 0, obj_player);

enum ECollisionMasks {
    NONE                    = 0b_0000_0000,
    DEFAULT                 = 0b_0000_0001,
    CLIMBABLE               = 0b_0000_0010,
    MOVING                  = 0b_0000_0100,
	SPELL_TARGET			= 0b_0000_1000,
	PICKUP					= 0b_0001_0000,
    
    ACTIVATOR               = 0b_0010_0000
}