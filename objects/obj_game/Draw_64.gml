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
    
    var scrib = scribble(bubble.text)
        .starting_format("fnt_game", c_white)
        .sdf_border(c_black, 2)
        .sdf_shadow(c_black, 0.5, 1, 1)
        .scale(.4)
        .wrap(max_speech_bubble_width - speech_bubble_padding)
        .align(fa_center, fa_middle);
    
    
    var ww = scrib.get_width() + speech_bubble_padding;
    var hh = scrib.get_height() + speech_bubble_padding;
    
    ww = ceil(ww / 32) * 32;
    hh = ceil(hh / 32) * 32;
    
    draw_sprite_stretched(bubble.parent.mind_read_sprite, bubble.parent.mind_read_sprite_index, location.x - ww / 2 , location.y - hh, ww, hh);
    
    scrib.draw(location.x, location.y - hh / 2, bubble.typist);
}