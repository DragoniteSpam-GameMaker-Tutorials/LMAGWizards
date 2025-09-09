self.active_chatterbox = undefined;
self.speaker = undefined;

self.chatterbox_line = "";

ChatterboxLoadFromFile("words/test.yarn", "test");
self.chatterboxes = {
    test: ChatterboxCreate("test", true)
};

self.PlayCutscene = function(speaker) {
    if (speaker.chatterbox_file != "" && speaker.chatterbox_node != "") {
        obj_game.SetGameState(EGameStates.CUTSCENE);
        self.active_chatterbox = self.chatterboxes[$ speaker.chatterbox_file];
        ChatterboxJump(self.active_chatterbox, speaker.chatterbox_node);
        if (ChatterboxGetContentCount(self.active_chatterbox) > 0) {
            self.chatterbox_line = ChatterboxGetContent(self.active_chatterbox, 0);
        }
    }
};