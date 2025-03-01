class_name WalkingPlayerState;
extends State;

@export var ANIMATION:AnimationPlayer;
@export var TOP_ANIM_SPEED:float=2.2;

func enter()->void:
  ANIMATION.play("walking",-1.0,1.0);
  Global.player._is_sprinting=false;

func update(delta):
  set_animation_speed(Global.player.velocity.length());
  if Global.player.velocity.length()==0.0:
    transition.emit("Idle");

func set_animation_speed(speed):
  var alpha=remap(speed,0.0,Global.player.SPEED,0.0,1.0);
  ANIMATION.speed_scale=lerp(0.0,TOP_ANIM_SPEED,alpha);

func _input(event: InputEvent)->void:
  if(event.is_action_pressed("sprint")):
    transition.emit("Sprinting");
