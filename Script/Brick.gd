extends RigidBody3D
class_name Brick

func destroy():
	#apply_force(Vector3.UP * 1000)
	Game.LevelFinishCheck()
	queue_free()

func _physics_process(delta: float) -> void:
	# FIXME For some reason when a brick is deostroed the one above him forgets it should fall
	apply_force(Vector3.DOWN * delta)
