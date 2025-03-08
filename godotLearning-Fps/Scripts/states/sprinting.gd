class_name SprintPlayerState;
extends PlayerMovementStateModule;

@export var TOP_ANIM_SPEED:float=1.6;
@export var SPEED:float=6.5;
@export var ACCELERATION:float=.25;
@export var DECELERATION:float=.25;

func enter(previous_state)->void:
  ANIMATION.play("sprinting",.5,1.0);
  Global.player._is_sprinting=true;

func update(delta:float)->void:
  PLAYER.update_gravity(delta);
  PLAYER.update_input(SPEED,ACCELERATION,DECELERATION);
  PLAYER.update_velocity();
  if(Input.is_action_just_pressed("crouch") and PLAYER.is_on_floor()):
    transition.emit("Sliding");
  set_animation_speed(PLAYER.velocity.length());
  if(Input.is_action_just_released("sprint")):
    transition.emit("Walking");

func set_animation_speed(speed):
  var alpha=remap(speed,0.0,PLAYER.SPEED_SPRINT,0.0,1.0);
  ANIMATION.speed_scale=lerp(0.0,TOP_ANIM_SPEED,alpha);
