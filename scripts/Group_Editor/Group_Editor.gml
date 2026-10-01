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
    },
    x: 0,
    y: 0,
    w: 400,
    h: 1080,
    spacing: 20
};