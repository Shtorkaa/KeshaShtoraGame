extends Area3D

func _on_body_entered(Body:Node3D) -> void:
	if Body is Ball:
		Body.out_of_map_bounds.emit()
		$UselessFnNccgd.play()

func _on_area_entered(Area:Area3D) -> void:
	if Area is Pickup:
		Area.die()
