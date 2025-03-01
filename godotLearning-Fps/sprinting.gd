class_name SprintPlayerState;
extends State;

@export var ANIMATION:AnimationPlayer;
@export var TOP_ANIM_SPEED:float=1.6;

func enter()->void:
  ANIMATION.play("sprinting",.5,1.0);
  Global.player._is_sprinting=true;

func update(delta:float)->void:
  set_animation_speed(Global.player.velocity.length());

func set_animation_speed(speed):
  var alpha=remap(speed,0.0,Global.player.SPEED_SPRINT,0.0,1.0);
  ANIMATION.speed_scale=lerp(0.0,TOP_ANIM_SPEED,alpha);

func _input(event: InputEvent)->void:
  if(event.is_action_released("sprint")):
    transition.emit("Walking");
