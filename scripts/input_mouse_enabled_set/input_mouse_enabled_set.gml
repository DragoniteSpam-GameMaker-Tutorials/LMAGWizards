/// @desc    Sets whether a player may use mouse to drive the cursor
/// @param   State
/// @param   [playerIndex=0]

function input_mouse_enabled_set(_state, _player_index = 0)
{
    __INPUT_GLOBAL_STATIC_LOCAL  //Set static _global
    __INPUT_VERIFY_PLAYER_INDEX

    _global.__players[_player_index].__mouse_enabled_set(_state);
}