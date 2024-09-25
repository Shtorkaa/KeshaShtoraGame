extends StaticBody3D
class_name Ball

var dir = Vector3.FORWARD
var speed = 1.0
var is_dead = false
var remove_on_death = [
	"Hitbox", "Model", # WARNING Required nodes
]

func move(vector:Vector3) -> KinematicCollision3D:
	var collision = move_and_collide(vector)
	position.y = Game.BallsSpawnHeight
	return collision

func die() -> void:
	if is_dead: return
	
	is_dead = true
	
	for node_path in remove_on_death: get_node(node_path).queue_free()
	
	$SoundDead.play()
	$Afterlife.start()
	
	Game.BallsEndedCheck()

func hit(collision:KinematicCollision3D, delta:float) -> void:
	var  collider = collision.get_collider()
	if   collider is Brick:
		# Im not sure why it works
		# if collider.is_dead: return
		collider.destroy()
		Game.SillyFreeze()
	elif collider is Ball:
		# Im not sure why it works
		# if collider.is_dead: return
		collider.die()
	elif collider is Wall:
		$SoundHitWall.play()
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

	print(['Ping', 'Pong'].pick_random())
	dir = dir.bounce(collision.get_normal())
	Game.SillyFreeze(0.05)
	$SoundHit.play()
	# Tecnically makes it move faster but idc, it fixes the double hit in certain cases
	move(dir * speed * delta)

func _physics_process(delta:float):
	if    is_dead: return
	var collision = move(dir * speed * delta)
	if !collision: return
	hit(collision, delta)

func _on_afterlife_timeout() -> void:
	queue_free()
