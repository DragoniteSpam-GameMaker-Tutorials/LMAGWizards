function ThoughtBubble(text, time_to_live, parent) constructor {
    self.text = text;
    self.time_to_live = time_to_live;
    self.parent = parent;
    
    static Update = function() {
        self.time_to_live -= DT;
    };
    
    static StillAlive = function() {
        return self.time_to_live > 0;
    };
}