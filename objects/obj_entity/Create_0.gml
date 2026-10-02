array_push(global.all_things, self.id);

self.xspeed = 0;
self.yspeed = 0;
self.zspeed = 0;

self.z = self.depth;
self.depth = 0;

self.OnSpellHit = function(spell) {
    if (spell.object_index != self.spell_response) return;
    
    // implementation pending...
};

self.motion = undefined;

self.state = undefined;

self.SetMesh = function(mesh) { };
self.UpdateCollisionPositions = function() { };

enum EEditorTypes {
    REAL,
    INT,
    STRING,
    BOOLEAN
}

self.editor_properties = [
    new EditorInspectorSection(
        "Position",
        [
            new EditorInspectorKey("x", EEditorTypes.REAL),
            new EditorInspectorKey("y", EEditorTypes.REAL),
            new EditorInspectorKey("z", EEditorTypes.REAL)
        ]
    ),
    new EditorInspectorSection(
        "General",
        [
            new EditorInspectorKey("seesaw_mass", EEditorTypes.REAL)
        ]
    ),
    new EditorInspectorSection(
        "General",
        [
            new EditorInspectorKey("chatterbox_file", EEditorTypes.STRING),
            new EditorInspectorKey("chatterbox_node", EEditorTypes.STRING)
        ]
    )
];