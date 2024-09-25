extends Area3D

var BASE_POSITION

func _on_body_entered(Body:Node3D) -> void:
	if Body is Ball:
		Body.die()
		$UselessFnNccgd.play()

func _on_area_entered(Area:Area3D) -> void:
	if Area is Pickup:
		Area.die()

func _ready() -> void:
	BASE_POSITION = position

func _physics_process(delta: float) -> void:
	# FIXME BUG I fucking hate my life
	position = BASE_POSITION + Vector3(randf_range(0.0, 0.1), randf_range(0.0, 0.1), randf_range(0.0, 0.1))
