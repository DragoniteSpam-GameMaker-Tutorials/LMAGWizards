function QuestData(name, ID, description) constructor {
    self.name = name;
    self.ID = ID;
    self.description = description;
}

#macro QuestDB global.__quest_db__

QuestDB = {
    cheese: new QuestData("Cheese", "cheese", "I like cheese. Get me some cheese."),
    door: new QuestData("Locked door", "door", "There's a locked door. It's very inconvenient. Please open it.")
};

enum EQuestStates {
    NOT_STARTED,
    STARTED,
    COMPLETED
}