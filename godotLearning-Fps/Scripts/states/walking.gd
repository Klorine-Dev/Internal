class_name WalkingPlayerState extends PlayerMovementStateModule;

@export var TOP_ANIM_SPEED:float=2.2;
@export var SPEED:float=4.0;
@export var ACCELERATION:float=.1;
@export var DECELERATION:float=.15;

func enter(previous_state)->void:
  ANIMATION.play("walking",-1.0,1.0);
  Global.player._is_sprinting=false;

func update(delta):
  PLAYER.update_gravity(delta);
  PLAYER.update_input(SPEED,ACCELERATION,DECELERATION);
  PLAYER.update_velocity();
  set_animation_speed(PLAYER.velocity.length());
  if(Input.is_action_just_released("crouch")):Global.crouch.uncrouch();
  if(Input.is_action_just_pressed("crouch") and PLAYER.is_on_floor()):transition.emit("Crouching");
  if(get_parent().CURRENT_STATE.name!="Crouching" and PLAYER.velocity.length()==0.0):transition.emit("Idle");
  if(get_parent().CURRENT_STATE.name!="Crouching" and Input.is_action_just_pressed("sprint")):transition.emit("Sprinting");
  if Input.is_action_just_pressed("move_jump") and PLAYER.is_on_floor():transition.emit("Jumping");
  if PLAYER.velocity.y<-3.0 and !PLAYER.is_on_floor():transition.emit("Falling");

func set_animation_speed(speed):
  var alpha=remap(speed,0.0,PLAYER.SPEED,0.0,1.0);
  ANIMATION.speed_scale=lerp(0.0,TOP_ANIM_SPEED,alpha);
