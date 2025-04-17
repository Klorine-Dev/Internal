class_name IdlePlyerState extends PlayerMovementStateModule;

func enter(previous_state)->void:ANIMATION.pause();
@export var SPEED:float=4.0;
@export var ACCELERATION:float=.1;
@export var DECELERATION:float=.15;

func update(delta):
  PLAYER.update_gravity(delta);
  PLAYER.update_input(SPEED,ACCELERATION,DECELERATION);
  PLAYER.update_velocity();
  if(Input.is_action_just_released("crouch")):Global.crouch.uncrouch();
  if Input.is_action_just_pressed("crouch") and PLAYER.is_on_floor():transition.emit("Crouching");
  if PLAYER.velocity.length()>0.0 and PLAYER.is_on_floor():transition.emit("Walking");
  if Input.is_action_just_pressed("move_jump") and PLAYER.is_on_floor():transition.emit("Jumping");
  if PLAYER.velocity.y<-3.0 and !PLAYER.is_on_floor():transition.emit("Falling");