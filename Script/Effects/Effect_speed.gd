extends Effect

var speed = 16.0
var speed_before

func _on_applied() -> void:
	speed_before = ball.speed
	ball.set_speed(speed)

func _on_cleared() -> void:
	ball.set_speed(speed_before)

func _on_shown() -> void:
	ball.hide_model(true)
	$Model.visible = true

func _on_hidden() -> void:
	ball.hide_model(false)
	$Model.visible = false
