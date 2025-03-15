class_name  SlidingPlayerState extends PlayerMovementStateModule;

@export var SPEED:float=6.0;
@export var ACCELERATION:float=.1;
@export var DECELERATION:float=.25;
@export var TILT_AMOUNT:float=.09;
@export_range(1,6,.1) var SLIDE_ANIM_SPEED:float=4.0;

func enter(previous_state)->void:
  set_tilt(PLAYER._current_rotation);
  ANIMATION.get_animation("sliding").track_set_key_value(5,0,PLAYER.velocity.length());
  ANIMATION.speed_scale=1.0;
  ANIMATION.play("sliding",-1.0,SLIDE_ANIM_SPEED);

func update(delta)->void:
  PLAYER.update_gravity(delta);
  PLAYER.update_velocity();

func set_tilt(player_rotation)->void:
  var tilt=Vector3.ZERO;
  tilt.z=clamp(TILT_AMOUNT+player_rotation,-.1,.1);
  if(tilt.z==0.0):tilt.z=.05;
  ANIMATION.get_animation("sliding").track_set_key_value(4,1,tilt);
  ANIMATION.get_animation("sliding").track_set_key_value(4,2,tilt);

func finish():
  transition.emit("Crouching");