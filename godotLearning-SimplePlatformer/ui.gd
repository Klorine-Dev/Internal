extends Control

func _on_button_pressed() -> void:
	self.hide();
	get_parent().show();
	# get_node("..").MovementEnabled=false;
	get_parent().MovementEnabled=true;
	get_tree().reload_current_scene();
