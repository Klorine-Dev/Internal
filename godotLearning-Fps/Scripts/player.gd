extends CharacterBody3D;

# movement vars
@export var SPEED:float=4.0;
@export var SPRINT_MULTIPLIER:float=1.65;
@export var SPEED_SPRINT:float=SPEED*SPRINT_MULTIPLIER;
@export var ACCELERATION:float=.1;
@export var DECELERATION:float=.15;
@export var JUMP_VELOCITY:float=4.5;
@export var ANIMATION_PLAYER:AnimationPlayer;
@export var CROUCH_SHAPECAST:ShapeCast3D;
@export var TOGGLE_CROUCH:bool=false;
@export_range(5,10,.1) var CROUCH_SPEED:float=7.0;
var _is_crouching:bool=false;
var _is_sprinting:bool=false;

# camera vars
@export var MOUSE_SENSITIVITY:float=.75;
@export var TILT_LOWER_LIMIT:=deg_to_rad(-90.0);
@export var TILT_UPPER_LIMIT:=deg_to_rad(90.0);
@export var CAMERA_CONTROLLER:Camera3D;
var _mouse_input:bool=false;
var _mouse_rotation:Vector3;
var _rotation_input:float;
var _tilt_input:float;
var _player_rotation:Vector3;
var _camera_rotation:Vector3;

func _ready()->void:
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED;
	Global.player=self;
	CROUCH_SHAPECAST.add_exception($".");

func _input(event: InputEvent)->void:
	if(event.is_action_pressed("exit")):
		if(Input.mouse_mode==Input.MOUSE_MODE_CAPTURED):
			Input.mouse_mode=Input.MOUSE_MODE_VISIBLE;
		else:get_tree().quit();
	#!deprecated sprint function
	# if(event.is_action_pressed("sprint")):_is_sprinting=true;
	# elif(event.is_action_released("sprint")):_is_sprinting=false;
	#!godot is gstinky
	#if(event.is_action_pressed("crouch") and TOGGLE_CROUCH):toggle_crouch();
	#if(event.is_action_pressed("crouch") and !_is_crouching and !TOGGLE_CROUCH):
	#	crouching(true);
	#if(event.is_action_pressed("crouch") and !TOGGLE_CROUCH):
	#	crouching(false);

func _unhandled_input(event:InputEvent)->void:
	if(Input.mouse_mode==Input.MOUSE_MODE_VISIBLE):
		if(event is InputEventMouseButton and 
		Input.is_mouse_button_pressed(1)):
			Input.mouse_mode=Input.MOUSE_MODE_CAPTURED;
	_mouse_input=(event is InputEventMouseMotion and Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED);
	if _mouse_input:
		_rotation_input=-event.relative.x*MOUSE_SENSITIVITY;
		_tilt_input=-event.relative.y*MOUSE_SENSITIVITY;

func _update_camera(delta):
	_mouse_rotation.x+=_tilt_input*delta;
	_mouse_rotation.x=clamp(_mouse_rotation.x,TILT_LOWER_LIMIT,TILT_UPPER_LIMIT);
	_mouse_rotation.y+=_rotation_input*delta;
	_player_rotation=Vector3(0.0,_mouse_rotation.y,0.0);
	_camera_rotation=Vector3(_mouse_rotation.x,0.0,0.0);
	CAMERA_CONTROLLER.transform.basis=Basis.from_euler(_camera_rotation);
	CAMERA_CONTROLLER.rotation.z=0.0;
	$CameraController/Camera3D.fov=lerp(
		float($CameraController/Camera3D.fov),
		125.0 if _is_sprinting else 90.0,.15
	);
	global_transform.basis=Basis.from_euler(_player_rotation);
	_rotation_input=0.0;
	_tilt_input=0.0;

func _physics_process(delta: float) -> void:
	Global.debug.add_prop("PlayerVelocity",velocity.length(),2);
	if not is_on_floor():velocity+=get_gravity()*delta;
	_update_camera(delta);
	if Input.is_action_just_pressed("move_jump") and is_on_floor():velocity.y=JUMP_VELOCITY;
	var input_dir:=Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	);
	var direction:=(transform.basis*Vector3(input_dir.x,0,input_dir.y)).normalized()
	if direction:
		if _is_sprinting:
			velocity.x=lerp(velocity.x,direction.x*SPEED_SPRINT,ACCELERATION);
			velocity.z=lerp(velocity.z,direction.z*SPEED_SPRINT,ACCELERATION);
		else:
			velocity.x=lerp(velocity.x,direction.x*SPEED,ACCELERATION);
			velocity.z=lerp(velocity.z,direction.z*SPEED,ACCELERATION);
	else:
		velocity.x=move_toward(velocity.x,0,DECELERATION);
		velocity.z=move_toward(velocity.z,0,DECELERATION);
	move_and_slide();

func toggle_crouch():
	#!doesn't work >:c
	if _is_crouching and !CROUCH_SHAPECAST.is_colliding():crouching(false);
	elif not _is_crouching:crouching(true);

func crouching(state:bool):
	match state:
		true:ANIMATION_PLAYER.play("crouch",0,CROUCH_SPEED);
		false:ANIMATION_PLAYER.play("crouch",0,-CROUCH_SPEED,true);

func _on_animation_player_animation_started(anim_name:StringName) -> void:
	if anim_name=="crouch":_is_crouching=!_is_crouching;
