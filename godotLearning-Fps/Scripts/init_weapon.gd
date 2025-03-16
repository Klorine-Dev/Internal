extends Node3D;

@export var WEAPON_TYPE:Weapons;

@export var weapon_mesh:MeshInstance3D;

func _ready()->void:load_weapon();

func load_weapon()->void:
  print("Switching to weapon: %s" % WEAPON_TYPE.name);
  weapon_mesh.mesh=WEAPON_TYPE.mesh;
  weapon_mesh.position=WEAPON_TYPE.position;
  weapon_mesh.scale=WEAPON_TYPE.scale;
  rotation_degrees=WEAPON_TYPE.rotation;
