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

self.spell_lookup = {
    bounce: obj_spell_bounce,
    push: obj_spell_push,
    mindread: obj_spell_mind_read,
    time: obj_spell_time,
    unlock: obj_spell_unlock,
    flower: obj_spell_flower
};

// untested
ChatterboxAddFunction("PlayerKnowsSpell", function(spell_name) {
    var spell_type = self.spell_lookup[$ spell_name];
    if (spell_type != undefined) {
        return GameState.KnowsSpell(spell_type);
    }
    show_error($"Spell does not exist: {spell_name}", true);
});
// untested
ChatterboxAddFunction("PlayerAddSpell", function(spell_name) {
    var spell_type = self.spell_lookup[$ spell_name];
    if (spell_type != undefined) {
        GameState.AddSpell(spell_type);
    } else {
        show_error($"Spell does not exist: {spell_name}", true);
    }
});
// untested
ChatterboxAddFunction("PlayerRemoveSpell", function(spell_name) {
    var spell_type = self.spell_lookup[$ spell_name];
    if (spell_type != undefined) {
        GameState.RemoveSpell(spell_type);
    } else {
        show_error($"Spell does not exist: {spell_name}", true);
    }
});

// untested
ChatterboxAddFunction("PlayerAddCurrency", function(amount) {
    GameState.AddCurrency(real(amount));
});
// untested
ChatterboxAddFunction("PlayerGetCurrency", function() {
    return GameState.GetCurrency();
});

// untested
ChatterboxAddFunction("PlayerAddCard", function(card_name) {
    var card_type = CardDB[$ card_name];
    if (card_type != undefined) {
        GameState.AddCard(card_type);
    } else {
        show_error($"Card does not exist: {card_name}", true);
    }
});
// untested
ChatterboxAddFunction("PlayerRemoveCard", function(card_name) {
    var card_type = CardDB[$ card_name];
    if (card_type != undefined) {
        GameState.RemoveCard(card_type);
    } else {
        show_error($"Card does not exist: {card_name}", true);
    }
});
// untested
ChatterboxAddFunction("PlayerHasCard", function(card_name) {
    var card_type = CardDB[$ card_name];
    if (card_type != undefined) {
        return GameState.HasCard(card_type);
    }
    show_error($"Card does not exist: {card_name}", true);
});

// untested
ChatterboxAddFunction("PlayerStartQuest", function(quest_name) {
    var quest_type = QuestDB[$ quest_name];
    if (quest_type != undefined) {
        GameState.StartQuest(quest_type);
    } else {
        show_error($"Quest does not exist: {quest_name}", true);
    }
});
// untested
ChatterboxAddFunction("PlayerCompleteQuest", function(quest_name) {
    var quest_type = QuestDB[$ quest_name];
    if (quest_type != undefined) {
        GameState.CompleteQuest(quest_type);
    } else {
        show_error($"Quest does not exist: {quest_name}", true);
    }
});
// untested
ChatterboxAddFunction("PlayerRemoveQuest", function(quest_name) {
    var quest_type = QuestDB[$ quest_name];
    if (quest_type != undefined) {
        GameState.RemoveQuest(quest_type);
    } else {
        show_error($"Quest does not exist: {quest_name}", true);
    }
});
// untested
ChatterboxAddFunction("PlayerHasStartedQuest", function(quest_name) {
    var quest_type = QuestDB[$ quest_name];
    if (quest_type != undefined) {
        return GameState.HasStartedQuest(quest_type);
    }
    show_error($"Quest does not exist: {quest_name}", true);
});
// untested
ChatterboxAddFunction("PlayerHasCompletedQuest", function(quest_name) {
    var quest_type = QuestDB[$ quest_name];
    if (quest_type != undefined) {
        return GameState.HasCompletedQuest(quest_type);
    }
    show_error($"Quest does not exist: {quest_name}", true);
});

#endregion