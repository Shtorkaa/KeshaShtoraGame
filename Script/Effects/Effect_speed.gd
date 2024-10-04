extends Effect

func _on_applied() -> void:
	ball.speed.set_modifier('speed_bonus', 26, ModifiableFloat.operations.fixed, true)

func _on_cleared() -> void:
	ball.speed.remove_modifier('speed_bonus')

func _on_shown() -> void:
	ball.hide_model(true)
	$Model.visible = true

func _on_hidden() -> void:
	ball.hide_model(false)
	$Model.visible = false
