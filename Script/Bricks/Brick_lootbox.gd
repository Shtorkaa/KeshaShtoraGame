extends Brick

func _on_died() -> void:
	Game.SpawnPickup(global_position)
