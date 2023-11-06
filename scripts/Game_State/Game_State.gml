#macro GameState global.__game_state__

GameState = new GameStateClass();

function GameStateClass() constructor {
    self.known_spells = [
        
    ];
	
	static KnowsSpell = function(spell) {
		return array_contains(self.known_spells, spell);
	};
	
	static AddSpell = function(spell) {
		if (!self.KnowsSpell(spell)) {
			array_push(self.known_spells, spell);
		}
	};
	
	static RemoveSpell = function(spell) {
		if (self.KnowsSpell(spell)) {
			array_delete(self.known_spells, array_get_index(self.known_spells, spell), 1);
		}
	};
};

GameState.AddSpell(obj_spell_push);
GameState.AddSpell(obj_spell_bounce);
GameState.AddSpell(obj_spell_unlock);
GameState.AddSpell(obj_spell_flower);