for (var i = array_length(self.thought_bubbles) - 1; i >= 0; i--) {
    var bubble = self.thought_bubbles[i];
    bubble.Update();
    if (!bubble.StillAlive()) {
        array_delete(self.thought_bubbles, i, 1);
    }
    
    var bubble_anchor = bubble.GetAnchorPoint();
    var location = world_to_screen(bubble_anchor.x, bubble_anchor.y, bubble_anchor.z, obj_game.camera.GetViewMat(), obj_game.camera.GetProjMat());
    
    var max_speech_bubble_width = 480;
    var speech_bubble_padding = 32;
    
    var ww = string_width_ext(bubble.text, -1, max_speech_bubble_width - speech_bubble_padding);
    var hh = string_height_ext(bubble.text, -1, max_speech_bubble_width - speech_bubble_padding) + speech_bubble_padding;
    
    ww = ceil(ww / 32) * 32;
    hh = ceil(hh / 32) * 32;
    
    draw_sprite_stretched(bubble.parent.mind_read_sprite, bubble.parent.mind_read_sprite_index, location.x - ww / 2 , location.y - hh, ww, hh);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    draw_set_colour(c_black);
    
    draw_text_ext(location.x, location.y - hh / 2, string_copy(bubble.text, 1, bubble.text_index), -1, ww - speech_bubble_padding);
}