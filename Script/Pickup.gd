extends Area3D
class_name Pickup

var speed = 5.0
var dir = Vector3(0, 0, -1)
var is_dead = false
var delete_on_death = [
	'Model', 'Hitbox', # WARNING Required nodes
]

signal collected
signal died

func die():
	# NOTE Could specify cause of death to call out more signals
	if is_dead: return
	
	print('Popped a pickup')
	is_dead = true
	
	for node_path in delete_on_death: get_node(node_path).queue_free()
	
	$Afterlife.start()
	
	died.emit()

func collect():
	if is_dead: return
	print('Just collected a pickup')
	collected.emit()
	die()

func _physics_process(delta:float) -> void:
	position += dir * speed / 100

func _on_body_entered(body:Node3D) -> void:
	if not body is Paddle: return push_warning('Pickup detected non paddle node; Fix collisions.')
	collect()

func _on_afterlife_timeout() -> void:
	queue_free()
