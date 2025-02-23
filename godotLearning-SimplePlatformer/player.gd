extends CharacterBody3D;
signal hit

var mouse_sensitivity:=0.005;
var pitch_input:=0.0;
var twist_input:=0.0;

const SPEED=5.0;
const JUMP_VELOCITY=4.5;

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

func _physics_process(delta: float) -> void:
	if(get_parent().MovementEnabled):
		if not is_on_floor():velocity+=get_gravity()*delta;
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y=JUMP_VELOCITY;
		if(Input.is_mouse_button_pressed(1)): Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
		var input_dir:=Input.get_vector(
			"ui_left",
			"ui_right",
			"ui_up",
			"ui_down"
		);
		var direction=($TwistPivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized();
		if Input.is_action_just_pressed("ui_cancel"): Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
		if direction:
			velocity.x=direction.x * SPEED;
			velocity.z=direction.z * SPEED;
		else:
			velocity.x=move_toward(velocity.x, 0, SPEED);
			velocity.z=move_toward(velocity.z, 0, SPEED);
		move_and_slide();
		$TwistPivot.rotate_y(twist_input);
		$TwistPivot/PitchPivot.rotate_x(pitch_input);
		$TwistPivot/PitchPivot.rotation.x=\
			clamp($TwistPivot/PitchPivot.rotation.x,-.5,.5);
		twist_input=0;
		pitch_input=0;

func _unhandled_input(event: InputEvent) -> void:
	if get_parent().MovementEnabled:
		if event is InputEventMouseMotion:
			if Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED:
				# if(Input.is_mouse_button_pressed(2)):
					twist_input=(-event.relative.x*mouse_sensitivity);
					pitch_input=(-event.relative.y*mouse_sensitivity);
