#macro GameState global.__game_state__

GameState = new GameStateClass();

function GameStateClass() constructor {
    self.known_spells = [
        obj_spell
    ];
};