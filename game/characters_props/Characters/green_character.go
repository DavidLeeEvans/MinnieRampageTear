components {
  id: "Antagonist"
  component: "/scripts/game/Antagonist.script"
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
embedded_components {
  id: "head"
  type: "sprite"
  data: "tile_set: \"/game/characters_props/Characters/character.atlas\"\n"
  "default_animation: \"green_character\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  ""
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
embedded_components {
  id: "left-hand"
  type: "sprite"
  data: "tile_set: \"/game/characters_props/Characters/character.atlas\"\n"
  "default_animation: \"green_hand\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  ""
  position {
    x: 47.0
    y: 58.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
embedded_components {
  id: "right-hand"
  type: "sprite"
  data: "tile_set: \"/game/characters_props/Characters/character.atlas\"\n"
  "default_animation: \"green_hand\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  ""
  position {
    x: 49.0
    y: -70.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
embedded_components {
  id: "wmd"
  type: "sprite"
  data: "tile_set: \"/game/characters_props/Characters/character.atlas\"\n"
  "default_animation: \"weapon_axe\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  ""
  position {
    x: 56.0
    y: 107.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
