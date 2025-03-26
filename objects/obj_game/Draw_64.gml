for (var i = array_length(self.thought_bubbles) - 1; i >= 0; i--) {
    var bubble = self.thought_bubbles[i];
    bubble.Update();
    if (!bubble.StillAlive()) {
        array_delete(self.thought_bubbles, i, 1);
    }
    
    var location = world_to_screen(bubble.parent.x, bubble.parent.y, bubble.parent.z, obj_game.camera.GetViewMat(), obj_game.camera.GetProjMat());
    
    show_debug_message(obj_game.camera.GetViewMat());
    
    draw_set_color(c_red);
    draw_circle(location.x, location.y, 40, false);
    
    show_debug_message(location);
}