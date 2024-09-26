extends RigidBody3D
class_name Brick

var is_dead = false
var remove_on_death = [
	"Hitbox", "Model", # WARNING Required nodes
]

# WARNING Not a good fit for the use case
signal died

func destroy():
	if is_dead: return
	
	is_dead = true
	
	for node_path in remove_on_death: get_node(node_path).queue_free()
	
	$SoundDestroy.play()
	$Afterlife.start()
	
	died.emit()
	
	Game.LevelFinishCheck()

func _physics_process(delta: float) -> void:
	# FIXME BUG For some reason when a brick is deostroed the one above him forgets it should fall, this is a not so good fix
	apply_force(Vector3.DOWN * delta)

func _on_afterlife_timeout() -> void:
	queue_free()
