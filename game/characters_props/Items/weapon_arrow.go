components {
  id: "Weapons"
  component: "/scripts/game/Weapons.script"
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
  properties {
    id: "type"
    value: "13.0"
    type: PROPERTY_TYPE_NUMBER
  }
}
embedded_components {
  id: "arrow"
  type: "sprite"
  data: "tile_set: \"/game/characters_props/Items/weapons.atlas\"\n"
  "default_animation: \"red_square\"\n"
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
