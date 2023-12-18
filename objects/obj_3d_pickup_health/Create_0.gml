event_inherited();

self.SetMesh(obj_game.meshes.card);

self.OnCollection = function() {
	GameState.AddHealth(1);
    show_debug_message("you have " + string(GameState.GetHealth()) + " health");
};