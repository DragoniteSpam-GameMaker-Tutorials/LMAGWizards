#macro GameState global.__game_state__

GameState = new GameStateClass();

function GameStateClass() constructor {
	self.currency = 0;
	
    self.known_spells = [
        
    ];
    
    self.cards = {
        
    };
	
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
	
	static AddCurrency = function(amount) {
		self.currency = max(0, self.currency + amount);
	};
    
    static AddCard = function(card) {
        self.cards[$ card.ID] = true;
    };
    
    static RemoveCard = function(card) {
        if (variable_struct_exists(self.cards, card.ID))
            variable_struct_remove(self.cards, card.ID);
    };
    
    static HasCard = function(card) {
        return variable_struct_exists(self.cards, card.ID);
    };
};

GameState.AddSpell(obj_spell_push);
GameState.AddSpell(obj_spell_bounce);
GameState.AddSpell(obj_spell_unlock);
GameState.AddSpell(obj_spell_flower);
GameState.AddSpell(obj_spell_time);