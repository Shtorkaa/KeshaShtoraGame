extends Area3D
class_name Pickup

var speed = 8.0
var dir = Vector3(0, 0, -1)
var is_dead = false
var remove_on_death = [
	'Model',
	'Hitbox',
]

signal collected
signal out_of_map_bounds
signal dead

func die():
	if is_dead: return
	print('Popped')
	is_dead = true
	for kid_full_name in remove_on_death:
		var kid = get_node(kid_full_name)
		if !kid: return
		kid.queue_free()
	$Afterlife.start()
	dead.emit()

func collect():
	print('Just collected a pickup')
	collected.emit()
	die()

func fell_out_of_map():
	print('Bye bye')
	out_of_map_bounds.emit()

func _physics_process(delta:float) -> void:
	position += dir * speed / 100

func _on_body_entered(body:Node3D) -> void:
	if not body is Paddle: return push_warning('Pickup detected a non paddle node; Fix collision.')
	collect()

func _on_afterlife_timeout() -> void:
	queue_free()
