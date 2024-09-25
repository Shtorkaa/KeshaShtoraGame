extends Brick

func _on_died() -> void:
	Game.SpawnBall(global_position)
