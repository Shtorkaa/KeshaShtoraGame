extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body is Ball:
		body.queue_free()
		$UselessFnNccgd.play()
