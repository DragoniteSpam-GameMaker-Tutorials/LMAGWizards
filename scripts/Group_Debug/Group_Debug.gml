#macro vk_editor_edit_mode          vk_f1

#macro Debug global.__debug__

Debug = {
    visuals: {
        show_collision: false,
        show_pathfinding: false
    },
    
    update: function() {
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
    dbg_view("Visualizations", false);
    dbg_checkbox(ref_create(Debug.visuals, "show_collision"));
    dbg_checkbox(ref_create(Debug.visuals, "show_pathfinding"));
    
    call_later(1, time_source_units_frames, function() {
        Debug.update();
    }, true);
}