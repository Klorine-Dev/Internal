class_name IdlePlyerState;
extends PlayerMovementStateModule;

func enter()->void:ANIMATION.pause();
@export var SPEED:float=4.0;
@export var ACCELERATION:float=.1;
@export var DECELERATION:float=.15;

func update(delta):
  PLAYER.update_gravity(delta);
  PLAYER.update_input(SPEED,ACCELERATION,DECELERATION);
  PLAYER.update_velocity();
  if Global.player.velocity.length()>0.0 and Global.player.is_on_floor():
    transition.emit("Walking");