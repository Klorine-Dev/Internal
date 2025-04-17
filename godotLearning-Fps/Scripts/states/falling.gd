class_name FallingPlayerState extends PlayerMovementStateModule;

@export var SPEED:float=6.0;
@export var ACCELERATION:float=.1;
@export var DECELERATION:float=.25;
@export var DOUBLE_JUMP_VELOCITY:float=4.0;

var DOUBLE_JUMP:bool=false;

func enter(previous_state)->void:
  ANIMATION.pause();

func exit()->void:
  DOUBLE_JUMP=false;

func update(delta)->void:
  PLAYER.update_gravity(delta);
  PLAYER.update_input(SPEED,ACCELERATION,DECELERATION);
  PLAYER.update_velocity();
  if Input.is_action_just_pressed("move_jump") and !DOUBLE_JUMP:
    DOUBLE_JUMP=true;
    PLAYER.velocity.y=DOUBLE_JUMP_VELOCITY;
  if PLAYER.is_on_floor():transition.emit("Idle");