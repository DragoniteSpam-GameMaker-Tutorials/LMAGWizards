event_inherited();

self.SetMesh(obj_game.meshes.card);

self.OnCollection = function() {
	GameState.AddCard(CardDB[$ self.card_id]);
};