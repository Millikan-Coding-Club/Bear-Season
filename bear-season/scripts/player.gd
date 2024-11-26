extends CharacterBody3D

@onready var twist = $Twist
@onready var pitch = $Twist/Pitch
@onready var camera = $Twist/Pitch/Camera3D


const speed = 5.0
const JUMP_VELOCITY = 4.5

var gravity = -9.8
var mouse_sensitivity := 0.003
var twist_input := 0.0
var pitch_input := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("right", "left", "down", "up")
	var direction = (twist.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = -direction.x * speed
		velocity.z = -direction.z * speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	twist.rotate_y(twist_input)
	pitch.rotate_x(pitch_input)
	pitch.rotation.x = clamp(pitch.rotation.x, -1.5, 1.5)
	twist_input = 0.0
	pitch_input = 0.0

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sensitivity
			pitch_input = -event.relative.y * mouse_sensitivity
