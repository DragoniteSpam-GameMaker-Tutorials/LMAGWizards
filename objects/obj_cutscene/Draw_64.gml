var ww = window_get_width() / 2;
var hh = window_get_height() / 2;

draw_set_color(c_white);
draw_rectangle(ww - 200, hh - 100, ww + 200, hh + 100, false);
draw_set_color(c_black);
draw_text(ww, hh, current_line);

if (input_check_pressed("action")) {
    obj_game.active_game_state = EGameStates.PLAYING;
}