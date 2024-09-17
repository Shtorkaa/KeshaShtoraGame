extends StaticBody3D
class_name Paddle

var Direction = Vector3.ZERO
var Speed = 10.0

var Rotation = 0
var RotationSpeed = 0.01
var RotationMax =  0.12
var RotationMin = -0.12

func _physics_process(DeltaTime: float):
	
	Direction = Vector3.ZERO
	if Game.CONTROLS_PRESSED['LEFT']:  Direction.x += 1
	if Game.CONTROLS_PRESSED['RIGHT']: Direction.x -= 1
	
	move_and_collide(Direction * Speed * DeltaTime)
	
	# Use this if you wanna balance the rotation when not moving
	var RotationDir = Direction.x if Direction.x != 0 else ((1 if Rotation < 0 else -1) if Rotation != 0 else 0)
	# Instead this
	# var RotationDir = Direction.x if Direction.x != 0 else 0
	
	Rotation = clamp(Rotation + RotationSpeed * RotationDir, RotationMin, RotationMax)
	rotation = Vector3(0, Game.Round(Rotation, 1), 0)
