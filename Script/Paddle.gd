extends StaticBody3D
class_name Paddle

func GetCollisionNormal(CollisionPoint: Vector3) -> Vector3:
	
	# Apply collision point like so https://media.discordapp.net/attachments/1229518358022717594/1280635939885940736/image.png?ex=66d8cca9&is=66d77b29&hm=f32c2e3b5b9a806a15b992c3ffcb6a94902de4787622022d106ecef8526b7e5d&=&format=webp&quality=lossless
	# Math gets kinda complex so its either us moxing to a conclusion that paddle always stays in one rotation so my brains dotn boil or boiling them
	
	return $CollisionNormal.position

func _physics_process(DeltaTime: float):
	
	var MoveDirection = Vector3.ZERO
	
	if Game.CONTROLS_PRESSED['LEFT']:  MoveDirection.x += 1
	if Game.CONTROLS_PRESSED['RIGHT']: MoveDirection.x -= 1
	
	position = clamp(position + MoveDirection * get_meta("Speed") * DeltaTime, get_meta('PositionMin'), get_meta('PositionMax'))
