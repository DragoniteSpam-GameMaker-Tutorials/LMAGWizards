self.active_chatterbox = undefined;
self.speaker = undefined;
self.chatterbox_line = undefined;
self.chatterbox_typist = undefined;

ChatterboxLoadFromFile("words/test.yarn", "test");
self.chatterboxes = {
    test: ChatterboxCreate("test", true)
};

self.SetUpContent = function(text) {
    self.chatterbox_line = scribble(text)
        .starting_format("fnt_game")
        .align(fa_center, fa_middle)
        .scale(0.5)
        .sdf_border(c_black, 2);
    self.chatterbox_typist = scribble_typist()
        .in(1, 2);
};

self.Continue = function() {
    if (ChatterboxIsWaiting(self.active_chatterbox)) {
        ChatterboxContinue(self.active_chatterbox);
    } else {
        //
    }
    
    if (ChatterboxIsStopped(self.active_chatterbox)) {
        self.active_chatterbox = undefined;
        self.speaker = undefined;
        self.chatterbox_line = undefined;
        self.chatterbox_typist = undefined;
        obj_game.SetGameState(EGameStates.PLAYING);
    } else {
        var line = ChatterboxGetContent(self.active_chatterbox, 0);
        self.SetUpContent(line);
    }
}

self.PlayCutscene = function(speaker, file = speaker.chatterbox_file, node = speaker.chatterbox_node) {
    if (file != "" && node != "") {
        self.speaker = speaker;
        obj_game.SetGameState(EGameStates.CUTSCENE);
        self.active_chatterbox = self.chatterboxes[$ file];
        ChatterboxJump(self.active_chatterbox, node);
        if (ChatterboxGetContentCount(self.active_chatterbox) > 0) {
            var line = ChatterboxGetContent(self.active_chatterbox, 0);
            self.SetUpContent(line);
        }
    }
};