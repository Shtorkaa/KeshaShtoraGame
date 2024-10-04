extends Effect

func _on_applied() -> void:
	$ParticlesHit.lifetime = get_time_left()
	$ParticlesHit.emitting = true
	ball.speed.set_modifier('paddle_boost_bonus', 15)

func _on_cleared() -> void:
	ball.speed.remove_modifier('paddle_boost_bonus')

func _on_shown() -> void:
	ball.hide_model(true)
	$Model.visible = true

func _on_hidden() -> void:
	ball.hide_model(false)
	$Model.visible = false
