#macro GameState global.__game_state__

GameState = new GameStateClass();

function GameStateClass() constructor {
	self.currency = 0;
    
    self.health_max = 10;
    self.health = self.health_max;
	
    self.known_spells = [
        
    ];
    
    self.cards = {
        
    };
	
    self.quests = {
        
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
    
    static StartQuest = function(quests) {
        if (!variable_struct_exists(self.quests, quests.ID))
            self.quests[$ quests.ID] = EQuestStates.STARTED;
    };
    
    static CompleteQuest = function(quests) {
        if (variable_struct_exists(self.quests, quests.ID))
            self.quests[$ quests.ID] = EQuestStates.COMPLETED;
    };
    
    static RemoveQuest = function(quests) {
        if (variable_struct_exists(self.quests, quests.ID))
            variable_struct_remove(self.quests, quests.ID);
    };
    
    static HasStartedQuest = function(quests) {
        return self.quests[$ quests.ID] == EQuestStates.STARTED;
    };
    
    static HasCompletedQuest = function(quests) {
        return self.quests[$ quests.ID] == EQuestStates.COMPLETED;
    };
    
    static AddHealth = function(amount) {
        self.health = min(self.health_max, self.health + amount);
    };
    
    static RemoveHealth = function(amount) {
        self.health = max(0, self.health - amount);
        if (self.health == 0) {
            // die
        }
    };
    
    static GetHealth = function() {
        return self.health;
    };
    
    static GetHealthPercent = function() {
        return self.health / self.health_max;
    };
};

GameState.AddSpell(obj_spell_push);
GameState.AddSpell(obj_spell_bounce);
GameState.AddSpell(obj_spell_unlock);
GameState.AddSpell(obj_spell_flower);
GameState.AddSpell(obj_spell_time);