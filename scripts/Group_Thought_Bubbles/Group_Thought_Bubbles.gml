function ThoughtBubble(text, time_to_live, parent) constructor {
    self.text = text;
    self.time_to_live = time_to_live;
    self.parent = parent;
    
    self.text_index = 0;
    
    static Update = function() {
        var characters_per_second = 50;
        
        self.time_to_live -= DT;
        self.text_index += characters_per_second * DT;
    };
    
    static StillAlive = function() {
        return self.time_to_live > 0;
    };
    
    static GetAnchorPoint = function() {
        return new Vector3(self.parent.x, self.parent.y + 40, self.parent.z);
    };
}