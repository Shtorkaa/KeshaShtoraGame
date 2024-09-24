extends RigidBody3D
class_name Brick

var is_dead = false
var remove_on_death = [
	"Hitbox",
	"Model",
]

func destroy():
	if is_dead: return
	is_dead = true
	Game.LevelFinishCheck()
	if Game.Proc(): Game.SpawnPickup(position) # Silly addition, remove later
	for kid_full_name in remove_on_death:
		var kid = get_node(kid_full_name)
		if !kid: return
		kid.queue_free()
	$SoundDestroy.play()
	$Afterlife.start()

func _physics_process(delta: float) -> void:
	# BUG For some reason when a brick is deostroed the one above him forgets it should fall, this is a not so good fix
	apply_force(Vector3.DOWN * delta)

func _on_afterlife_timeout() -> void:
	queue_free()
