self.active_chatterbox = undefined;
self.speaker = undefined;

self.chatterbox_line = "";

ChatterboxLoadFromFile("words/test.yarn", "test");
self.chatterboxes = {
    test: ChatterboxCreate("test", true)
};

self.PlayCutscene = function(speaker, file = speaker.chatterbox_file, node = speaker.chatterbox_node) {
    if (file != "" && node != "") {
        self.speaker = speaker;
        obj_game.SetGameState(EGameStates.CUTSCENE);
        self.active_chatterbox = self.chatterboxes[$ file];
        ChatterboxJump(self.active_chatterbox, node);
        if (ChatterboxGetContentCount(self.active_chatterbox) > 0) {
            self.chatterbox_line = ChatterboxGetContent(self.active_chatterbox, 0);
        }
    }
};