extends Node3D

@export var MovementEnabled: bool=true;

func _ready()->void:
	$UI/RespawnScreen.hide();
	$UI.hide();
	
func _on_area_3d_body_entered(body:Node3D)->void:
	if(body.name=="Player"):
		# get_tree().reload_current_scene();
		$UI/RespawnScreen.show();
		$UI.show();
		MovementEnabled=false;
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
