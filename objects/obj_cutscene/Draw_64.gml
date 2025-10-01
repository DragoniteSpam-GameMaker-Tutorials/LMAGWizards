var ww = window_get_width() / 2;
var hh = window_get_height() / 2;

var box_padding = 32;
var box_width = 800;
var box_height = 200;
var box_center_x = ww;
var box_center_y = box_height / 2 + box_padding;

var box_x1 = box_center_x - box_width / 2;
var box_y1 = box_center_y - box_height / 2;
var box_x2 = box_x1 + box_width;
var box_y2 = box_y1 + box_height;

if (self.speaker != undefined) {
    var view_mat = obj_game.camera.GetViewMat();
    var proj_mat = obj_game.camera.GetProjMat();
    var screen_coords = world_to_screen(self.speaker.x, self.speaker.y + 32, self.speaker.z, view_mat, proj_mat);
    if (screen_coords != undefined) {
        if (screen_coords.y < box_y2 + box_padding) {
            box_center_y = window_get_height() - box_height / 2 - box_padding;
            box_y1 = box_center_y - box_height / 2;
            box_y2 = box_y1 + box_height;
        }
    }
}

draw_set_color(c_white);
draw_rectangle(box_x1, box_y1, box_x2, box_y2, false);
draw_set_color(c_black);
draw_text(box_center_x, box_center_y, self.chatterbox_line);

if (input_check_pressed("action")) {
    obj_game.SetGameState(EGameStates.PLAYING);
}