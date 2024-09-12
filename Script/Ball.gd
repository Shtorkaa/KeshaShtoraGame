extends RigidBody3D
class_name Ball

var dir = Vector3(randf_range(0, .4), randf_range(0, .4), randf_range(0, .4)) # -get_global_transform().basis.z
var speed = 9.0

func move_forward(DeltaTime: float) -> KinematicCollision3D:
	return move_and_collide(dir * speed * DeltaTime)

func _physics_process(DeltaTime: float):
	var collision = move_forward(DeltaTime)
	
	if collision:
		var collider = collision.get_collider()
		
		Game.SillyFreeze(0.05)
		
		if collider is Brick:
			collider.destroy()
			Game.SillyFreeze()
			$Destroy8PkWymg.play()
		elif collider is Wall:
			$"You-cant-escape2hxFfar".play()
			print([
				'Yui tells you that there is no escape,',
				'Yui tells you there is no where to go,',
			].pick_random() + ' ' +
			[
				'you feel depressed.',
				'you feel down.',
				'you feel sad.',
				'you feel as if there is no hope.',
				'you feel as if there is really no hope.',
				'you feel punished.',
				'you feel as if this is your fault.',
				'you feel that you should have stayed home.',
				'you dont wanna deal with this.',
				'you wanna give up.',
			].pick_random())
			
		$"Parry-ultrakill".play()
		
		dir = dir.bounce(collision.get_normal())
		
		# Tencnically speeds it up but otherwise its clanky
		move_forward(DeltaTime * 3)
