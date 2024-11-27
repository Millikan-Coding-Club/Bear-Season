extends CharacterBody3D

@onready var agent = $NavigationAgent3D
@onready var player = $"../Player"
@onready var bear_anim = $AnimationPlayer

var SPEED = 3
var targ: Vector3

var rng = RandomNumberGenerator.new()
var rng_dis = 30

func _ready():
	rng.randomize()
	targ = Vector3(randf_range(position.x - rng_dis, position.x + rng_dis),0,randf_range(position.z - rng_dis, position.z + rng_dis))
	updateTargetLocation(targ)

func _physics_process(delta):
	if dead == false:
		look_at(targ)
		rotation.x = 0
		rotation.z = 0
		
		if position.distance_to(targ) > 3:
			var curLoc = global_transform.origin
			var nextLoc = agent.get_next_path_position()
			var newVel = (nextLoc - curLoc).normalized() * SPEED
			targ.y = position.y
			velocity = newVel
			move_and_slide()
		else:
			rng.randomize()
			targ = Vector3(randf_range(position.x - rng_dis, position.x + rng_dis),0,randf_range(position.z - rng_dis, position.z + rng_dis))
			updateTargetLocation(targ)

func updateTargetLocation(target):
	agent.set_target_position(target)

func _on_update_path_timeout():
	if dead == false:
		if position.distance_to(player.position) < 10:
			targ = player.position
			updateTargetLocation(targ)

var dead = false
func die():
	dead = true
	$CollisionShape3D.disabled = true
	$CollisionShape3D2.disabled = true
	$CollisionShape3D3.disabled = true
	$CollisionShape3D4.disabled = true
	bear_anim.play("death")
	
