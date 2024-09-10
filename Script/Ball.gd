extends RigidBody3D

var MetaPosition = Vector3.ZERO

func MoveForward(DeltaTime: float = 1.0) -> KinematicCollision3D:
	var FORWARD = -get_global_transform().basis.z
	
	return move_and_collide(FORWARD * get_meta('Speed') * DeltaTime)

func _physics_process(DeltaTime: float):
	
	var Collision = MoveForward(DeltaTime)
	
	if Collision:
		print(Collision.get_normal())
		rotate(Vector3(0, 1, 0), deg_to_rad(90 + rotation.y + 45 + rad_to_deg(Collision.get_collider().rotation.y) * 3))
		position = MetaPosition
		# set_meta("Speed", clamp(get_meta("Speed") * 1.25, 0, 60))
	
	MetaPosition = position

func _on_body_entered(Body: Node):
	
	if Body is Paddle:
		print(rotation)
		rotate(Vector3(0, 1, 0), 90)
		print(rotation)
