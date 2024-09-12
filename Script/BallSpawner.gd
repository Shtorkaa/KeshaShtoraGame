extends StaticBody3D

func _on_cooldown_timeout() -> void:
	Game.SpawnBall(position)
