extends Effect

func _on_applied() -> void:
	ball.speed.set_modifier('paddle_boost_bonus', 12)

func _on_cleared() -> void:
	ball.speed.remove_modifier('paddle_boost_bonus')

func _on_shown() -> void:
	ball.hide_model(true)
	$ParticlesActive.emitting = true
	$ParticlesActive.visible = true
	$Model.visible = true

func _on_hidden() -> void:
	ball.hide_model(false)
	$ParticlesActive.visible = false
	$Model.visible = false
