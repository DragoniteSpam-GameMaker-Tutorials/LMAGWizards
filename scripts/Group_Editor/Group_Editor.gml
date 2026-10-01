function EditorInspectorSection(name, keys) constructor {
    self.name = name;
    self.keys = keys;
}

function EditorInspectorKey(key, type) constructor {
    self.key = key;
    self.type = type;
}

#macro Editor global.__editor__

Editor = {
    cursor: {
        floor_z: 0,
        snapping: 8
    }
};