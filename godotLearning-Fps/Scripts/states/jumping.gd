class_name JumpingPlayerState extends PlayerMovementStateModule;

@export var SPEED:float=6.0;
@export var ACCELERATION:float=.1;
@export var DECELERATION:float=.25;
@export var JUMP_VELOCITY:float=5.0;
# @export var DOUBLE_JUMP_VELOCITY:float=4.0;
@export var COYOTE_TIMER:Timer;
@export_range(.5,1.0,.01) var INPUT_MULTIPLIER:float=.85;
# var _can_jump:bool=true;
# var _coyote:bool=false;

func enter(previous_state)->void:
  PLAYER.velocity.y+=JUMP_VELOCITY;
  # Global.debug.add_prop("CanJump?",_can_jump,3);
  ANIMATION.pause();
  # if Input.is_action_just_pressed("move_jump") and _can_jump:
    # PLAYER.velocity.y=JUMP_VELOCITY;
    # _can_jump=false;

func update(delta):
  PLAYER.update_gravity(delta);
  PLAYER.update_input(SPEED*INPUT_MULTIPLIER,ACCELERATION,DECELERATION);
  PLAYER.update_velocity();
  if PLAYER.velocity.y<-3.0 and !PLAYER.is_on_floor():transition.emit("Falling");
  if Input.is_action_just_released("move_jump"):
    if PLAYER.velocity.y>0:
      PLAYER.velocity.y=PLAYER.velocity.y/1.5;
  if PLAYER.is_on_floor():
    transition.emit("Idle");
    # _coyote=false;
    # _can_jump=true;
  # elif !PLAYER.is_on_floor() and !_coyote:
    # _coyote=true;
    # COYOTE_TIMER.start();
  
func _on_coyote_timer_timeout()->void:
  pass;
  # _can_jump=false;
  # _coyote=false;