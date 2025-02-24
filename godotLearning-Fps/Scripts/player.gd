# left off at 8:46
# https://www.youtube.com/watch?v=N-jh8qc8tJs
extends CharacterBody3D;

const SPEED=5.0;
const JUMP_VELOCITY=4.5;

@export var TILT_LOWER_LIMIT:=deg_to_rad(-90.0);
@export var TILT_UPPER_LIMIT:=deg_to_rad(90.0);
@export var CAMERA_CONTROLLER:Camera3D;
var _mouse_input:bool=false;
var _rotation_input:float;
var _tilt_input:float;

func _ready()->void:
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED;

func _input(event: InputEvent)->void:
	if(event.is_action_pressed("exit")):get_tree().quit();

func _unhandled_input(event:InputEvent)->void:
	_mouse_input=(event is InputEventMouseMotion and Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED);
	if _mouse_input:
		_rotation_input=-event.relative.x;
		_tilt_input=-event.relative.y;


func _physics_process(delta: float) -> void:
	if not is_on_floor():velocity+=get_gravity()*delta;
	if Input.is_action_just_pressed("move_jump") and is_on_floor():velocity.y=JUMP_VELOCITY;
	var input_dir:=Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	);
	var direction:=(transform.basis*Vector3(input_dir.x,0,input_dir.y)).normalized()
	if direction:
		velocity.x=direction.x*SPEED;
		velocity.z=direction.z*SPEED;
	else:
		velocity.x=move_toward(velocity.x,0,SPEED);
		velocity.z=move_toward(velocity.z,0,SPEED);
	move_and_slide();
