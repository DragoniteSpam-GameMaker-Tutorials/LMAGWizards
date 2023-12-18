if (keyboard_check(vk_escape)) game_end();

if (keyboard_check_pressed(vk_backspace)) {
    var f = file_text_open_read("test.json");
    var json = json_parse(file_text_read_string(f));
    file_text_close(f);
    
    GameState.Load(json);
}