extends Area3D

func _on_body_entered(Body:Node3D) -> void:
	# I dont think its possible to turn this into a switch case
	if Body is Ball:
		Body.out_of_map_bounds.emit()
		$UselessFnNccgd.play()

func _on_area_entered(Area:Area3D) -> void:
	if Area is Pickup:
		Area.fell_out_of_map()
