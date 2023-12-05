function CollectableCardData(name, ID, sprite, description) constructor {
    self.name = name;
    self.ID = ID;
    self.sprite = sprite;
    self.description = description;
}

#macro CardDB global.__card_db__

CardDB = {
    daisy: new CollectableCardData("Daisy", "daisy", spr_noise, "description of a daisy"),
    coneflower: new CollectableCardData("Coneflower", "coneflower", spr_noise, "description of a coneflower"),
    snapdragon: new CollectableCardData("Snapdragon", "snapdragon", spr_noise, "description of a daisy")
};