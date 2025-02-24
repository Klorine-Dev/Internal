extends Node3D

@export var MovementEnabled: bool=true;
@export var PlayerHealth: int=100; #$Player/PlayerHealth.Health

func _ready()->void:
	$UI/RespawnScreen.hide();
	$UI.hide();
	
func die()->void:
	# get_tree().reload_current_scene();
	$UI/RespawnScreen.show();
	$UI.show();
	MovementEnabled=false;
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);

var delta: float
func _process(_delta:float)->void:
	# PlayerHealth=$Player/PlayerHealth.Health;
	if(PlayerHealth<=0):die();
	delta=_delta;

# func SetPlayerHealth(amt:int)->void:
# 	if PlayerHealth-amt>=0:PlayerHealth=amt;
# 	else:die();
@export var WhilePlayerTouching:bool=false;
func _on_area_3d_body_entered(body:Node3D)->void:
	if(body.name=="Player"):
		WhilePlayerTouching=true;
		$Player/DamageTimer.start();
		PlayerHealth-=20;
		# die();

func _on_killbrick_collision_body_exited(body:Node3D) -> void:
	if(body.name=="Player"):
		WhilePlayerTouching=false;


func _on_player_hit() -> void:
	PlayerHealth-=20;
