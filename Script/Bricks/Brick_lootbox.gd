extends Brick

func _on_died() -> void:
	print('Spawning')
	Game.SpawnPickup(global_position)
