extends RigidBody3D

var MetaPosition = Vector3.ZERO

#func MoveForward(DeltaTime: float = 1.0) -> KinematicCollision3D:
	#var FORWARD = -get_global_transform().basis.z
	#
	#return move_and_collide(FORWARD * get_meta('Speed') * DeltaTime)

var dir = -get_global_transform().basis.z

func _physics_process(DeltaTime: float):
	var Collision = move_and_collide(dir * get_meta('Speed') * DeltaTime)
	
	if Collision:
		var axis = Vector3(1, 0, 0) 
		dir = dir.bounce(Collision.get_normal())
		position = MetaPosition
	
	MetaPosition = position

func _on_body_entered(Body: Node):
	
	if Body is Paddle:
		print(rotation)
		rotate(Vector3(0, 1, 0), 90)
		print(rotation)
