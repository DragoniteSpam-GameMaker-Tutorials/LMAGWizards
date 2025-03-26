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
    
    #region save and load
    static Save = function() {
        var json = {
            currency: self.currency,
            health_max: self.health_max,
            health: self.health,
            
            cards: self.cards,
            quests: self.quests,
            
            spells: array_create(array_length(self.known_spells))
        };
        
        for (var i = 0, n = array_length(self.known_spells); i < n; i++) {
            switch (self.known_spells[i]) {
                case obj_spell_bounce: json.spells[i] = ESpellTypes.BOUNCE; break;
                case obj_spell_flower: json.spells[i] = ESpellTypes.BLOOM; break;
                case obj_spell_push: json.spells[i] = ESpellTypes.PUSH; break;
                case obj_spell_time: json.spells[i] = ESpellTypes.SLOW_TIME; break;
                case obj_spell_unlock: json.spells[i] = ESpellTypes.UNLOCK; break;
                case obj_spell_mind_read: json.spells[i] = ESpellTypes.MIND_READ; break;
            }
        }
        
        return json;
    };
    
    static Load = function(json) {
        self.currency = json.currency;
        self.health_max = json.health_max;
        self.health = json.health;
        
        self.cards = json.cards;
        self.quests = json.quests;
        
        self.known_spells = array_create(array_length(json.spells));
        for (var i = 0, n = array_length(self.known_spells); i < n; i++) {
            switch (json.spells[i]) {
                case ESpellTypes.BOUNCE: self.known_spells[i] = obj_spell_bounce; break;
                case ESpellTypes.BLOOM: self.known_spells[i] = obj_spell_flower; break;
                case ESpellTypes.PUSH: self.known_spells[i] = obj_spell_push; break;
                case ESpellTypes.SLOW_TIME: self.known_spells[i] = obj_spell_time; break;
                case ESpellTypes.UNLOCK: self.known_spells[i] = obj_spell_unlock; break;
                case ESpellTypes.MIND_READ: self.known_spells[i] = obj_spell_mind_read; break;
            }
        }
    };
    #endregion
};

GameState.AddSpell(obj_spell_push);
GameState.AddSpell(obj_spell_bounce);
GameState.AddSpell(obj_spell_unlock);
GameState.AddSpell(obj_spell_flower);
GameState.AddSpell(obj_spell_time);
GameState.AddSpell(obj_spell_mind_read);