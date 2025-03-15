class_name CrouchingPlayerState extends PlayerMovementStateModule;

@export var SPEED:float=3.0;
@export var ACCELERATION:float=.1;
@export var DECELERATION:float=.25;
@export var IGNORE_CROUCH:Array[StaticBody3D];
@export_range(1,6,.1) var CROUCH_SPEED:float=4.0;

@export var CROUCH_SHAPECAST:ShapeCast3D;
var RELEASED:bool=false;

func ready()->void:
  Global.crouch=self;
  CROUCH_SHAPECAST.add_exception(PLAYER);
  CROUCH_SHAPECAST.add_exception(get_tree().root.get_node("Floor/FloorStaticBody3D"));
  for IgnoredObject in IGNORE_CROUCH:
    CROUCH_SHAPECAST.add_exception(IgnoredObject);


func enter(previous_state)->void:
  ANIMATION.speed_scale=1.0;
  if(previous_state.name!="Sliding"):
    ANIMATION.play("crouch",-1.0,CROUCH_SPEED);
  elif(previous_state.name=="Sliding"):
    ANIMATION.current_animation="crouch";
    ANIMATION.seek(1.0,true);

func exit()->void:RELEASED=false;

func update(delta):
  PLAYER.update_gravity(delta);
  PLAYER.update_input(SPEED,ACCELERATION,DECELERATION)
  PLAYER.update_velocity();
  
  if Input.is_action_just_released("crouch"):
    uncrouch();
  elif !Input.is_action_pressed("crouch") and RELEASED==false:
    RELEASED=true;
    uncrouch();

func uncrouch():
  # if !CROUCH_SHAPECAST.is_colliding() and !Input.is_action_just_pressed("crouch"):
  ANIMATION.play("crouch",-1.0,-CROUCH_SPEED*1.5,true);
  if ANIMATION.is_playing():
    await ANIMATION.animation_finished;
    transition.emit("Idle");
  # elif CROUCH_SHAPECAST.is_colliding():
    # print(CROUCH_SHAPECAST.get_collider(0).name);
    # await get_tree().create_timer(.1).timeout;
