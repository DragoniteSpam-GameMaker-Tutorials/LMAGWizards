#macro vk_editor_collision          vk_f1
#macro vk_editor_edit_mode          vk_f2

#macro Debug global.__debug__

Debug = {
    visuals: {
        show_collision: false
    },
    
    update: function() {
        if (keyboard_check_pressed(vk_editor_collision)) {
            Debug.visuals.show_collision = !Debug.visuals.show_collision;
        }
        if (keyboard_check_pressed(vk_editor_edit_mode)) {
            if (IS_PLAYING) {
                obj_game.SetGameState(EGameStates.EDITOR);
            } else if (IS_EDITOR) {
                obj_game.SetGameState(EGameStates.PLAYING);
            }
        }
    }
};

if (DEBUG) {
    call_later(1, time_source_units_frames, function() {
        Debug.update();
    }, true);
}