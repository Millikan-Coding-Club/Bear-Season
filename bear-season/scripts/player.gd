extends CharacterBody3D

@onready var twist = $Twist
@onready var pitch = $Twist/Pitch
@onready var camera = $Twist/Pitch/Camera3D
@onready var step_sfx = $Step_sfx
@onready var gun_camera = $GunOverlay/SubViewportContainer/SubViewport/GunCamera

const speed = 5.0
const JUMP_VELOCITY = 4.5

var gravity = -9.8
var mouse_sensitivity := 0.003
var twist_input := 0.0
var pitch_input := 0.0

var ammo = 10:
	set(e):
		ammo = e
		$"../UI/Ammo".text = "AMMO "+str(e)
var shots = 2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
var step_delay = false
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
	
	if velocity != Vector3(0, 0, 0) && is_on_floor() && step_delay == true:
		step_sfx.play()
		step_delay = false
		await get_tree().create_timer(.44).timeout
		step_delay = true
	
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

func _process(delta):
	gun_camera.global_transform = camera.global_transform
	var MainEnv = camera.get_environment()
	gun_camera.set_environment(MainEnv)
