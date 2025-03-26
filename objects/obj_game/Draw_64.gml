for (var i = array_length(self.thought_bubbles) - 1; i >= 0; i--) {
    var bubble = self.thought_bubbles[i];
    bubble.Update();
    if (!bubble.StillAlive()) {
        array_delete(self.thought_bubbles, i, 1);
    }
    
    var bubble_anchor = bubble.GetAnchorPoint();
    var location = world_to_screen(bubble_anchor.x, bubble_anchor.y, bubble_anchor.z, obj_game.camera.GetViewMat(), obj_game.camera.GetProjMat());
    
    draw_set_color(c_red);
    draw_circle(location.x, location.y, 40, false);
}