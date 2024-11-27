extends Node3D

@onready var player = $"../../.."
@onready var gun_anim = $AnimationPlayer
@onready var gun_anim2 = $AnimationPlayer2
@onready var ray_cast = $"../RayCast3D"
@onready var shoot_particles = $GPUParticles3D
@onready var shoot_particles2 = $GPUParticles3D2

var aiming = false
func _unhandled_input(event):
	if Input.is_action_just_pressed("reload") && player.ammo > 0 && player.shots < 2:
		player.ammo -= 2
		$reload.play()
		gun_anim.play("Reload")
		await gun_anim.animation_finished
		player.shots = 2
	if Input.is_action_just_pressed("shoot") && player.shots > 0:
		player.shots = 0
		shoot_particles.emitting = true
		shoot_particles2.emitting = true
		if ray_cast.is_colliding():
			ray_cast.get_collider().get_parent().die()
			$kill.play()
		else:
			$fire.play()
		if aiming == false:
			gun_anim2.play("shoot")
		else:
			gun_anim2.play("shoot2")
	elif Input.is_action_just_pressed("shoot"):
		$click.play()
	if Input.is_action_pressed("aim"):
		if aiming == false:
			gun_anim2.play("aim")
		aiming = true
	else:
		if aiming == true:
			gun_anim2.play_backwards("aim")
		aiming = false
		
