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

draw_sprite_stretched(spr_windowskin, 0, box_x1, box_y1, box_width, box_height);
self.chatterbox_line
    .wrap(box_width - box_padding * 2)
    .draw(box_center_x, box_center_y, self.chatterbox_typist);

if (array_length(self.chatterbox_option_lines) > 0) {
    var option_max_width = 0;
    var option_total_height = 0;
    
    for (var i = 0; i < array_length(self.chatterbox_option_lines); i++) {
        var option = self.chatterbox_option_lines[i];
        option_max_width = max(option_max_width, option.get_width());
        option_total_height += option.get_height();
    }
    
    var option_box_x1 = box_x2 - box_padding * 2 - option_max_width;
    var option_box_y1 = box_y2 + box_padding;
    var option_box_x2 = box_x2;
    var option_box_y2 = option_box_y1 + box_padding * 2 + option_total_height;
    
    draw_sprite_stretched(spr_windowskin, 0, option_box_x1, option_box_y1, option_box_x2 - option_box_x1, option_box_y2 - option_box_y1);
    
    var option_y = option_box_y1 + box_padding;

    for (var i = 0; i < array_length(self.chatterbox_option_lines); i++) {
        var option = self.chatterbox_option_lines[i];
        option
            .draw(option_box_x2 - box_padding, option_y);
        
        option_y += option.get_height();
    }
}

if (input_check_pressed("action")) {
    if (self.chatterbox_typist.get_state() == 1) {
        self.Continue();
    } else {
        self.chatterbox_typist.in(3, 2);
    }
}