extends Pickup

func _on_collected() -> void:
	$SoundCollect.play()
	Game.ApplyEffect('speed')
