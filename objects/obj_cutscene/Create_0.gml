self.active_chatterbox = undefined;
self.speaker = undefined;
self.chatterbox_line = undefined;
self.chatterbox_typist = undefined;
self.chatterbox_option_lines = [];
self.chatterbox_option_selected = 0;

ChatterboxLoadFromFile("words/test.yarn", "test");
self.chatterboxes = {
    test: ChatterboxCreate("test", true)
};

self.SetUpContent = function(chatterbox) {
    var text = ChatterboxGetContent(chatterbox, 0);
    var options = ChatterboxGetOptionArray(chatterbox);
    
    self.chatterbox_line = scribble(text)
        .starting_format("fnt_game")
        .align(fa_center, fa_middle)
        .scale(0.5)
        .sdf_border(c_black, 2);
    self.chatterbox_typist = scribble_typist()
        .in(1, 2);
    
    self.chatterbox_option_selected = 0;
    self.chatterbox_option_lines = array_create(array_length(options));
    
    for (var i = 0; i < array_length(options); i++) {
        self.chatterbox_option_lines[i] = scribble(options[i].text)
            .starting_format("fnt_game")
            .align(fa_right, fa_top)
            .scale(0.5)
            .sdf_border(c_black, 2);
    }
};

self.Continue = function() {
    if (ChatterboxIsWaiting(self.active_chatterbox)) {
        ChatterboxContinue(self.active_chatterbox);
    } else {
        ChatterboxSelect(self.active_chatterbox, self.chatterbox_option_selected);
    }
    
    if (ChatterboxIsStopped(self.active_chatterbox)) {
        self.active_chatterbox = undefined;
        self.speaker = undefined;
        self.chatterbox_line = undefined;
        self.chatterbox_typist = undefined;
        self.chatterbox_option_selected = 0;
        obj_game.SetGameState(EGameStates.PLAYING);
    } else {
        self.SetUpContent(self.active_chatterbox);
    }
}

self.PlayCutscene = function(speaker, file = speaker.chatterbox_file, node = speaker.chatterbox_node) {
    if (file != "" && node != "") {
        obj_game.thought_bubbles = [];
        
        self.speaker = speaker;
        obj_game.SetGameState(EGameStates.CUTSCENE);
        self.active_chatterbox = self.chatterboxes[$ file];
        ChatterboxJump(self.active_chatterbox, node);
        if (ChatterboxGetContentCount(self.active_chatterbox) > 0) {
            self.SetUpContent(self.active_chatterbox);
        }
    }
};

#region chatterbox functions
ChatterboxAddFunction("PlayerAddHealth", function(amount) {
    GameState.AddHealth(real(amount));
});

ChatterboxAddFunction("PlayerRemoveHealth", function(amount) {
    GameState.RemoveHealth(real(amount));
});

ChatterboxAddFunction("PlayerGetHealth", function() {
    return GameState.GetHealth();
});

ChatterboxAddFunction("PlayerGetHealthPercent", function() {
    return GameState.GetHealthPercent();
});
/*
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
    */
#endregion