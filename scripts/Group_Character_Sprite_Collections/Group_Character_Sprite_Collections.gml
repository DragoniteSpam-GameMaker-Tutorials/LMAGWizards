function CharacterSpriteCollection(front, back, side) constructor {
    self.front = front;
    self.back = back;
    self.side = side;
}

#macro CharacterSprites global.__character_sprites__

CharacterSprites = {
    duck: new CharacterSpriteCollection(spr_character_duck_front, spr_character_duck_back, spr_character_duck_side)
};