extends RigidBody3D
class_name Ball

var dir = Vector3(randf_range(0, .4), randf_range(0, .4), randf_range(0, .4)) # -get_global_transform().basis.z
var speed = 9.0
var respawn_when_out_of_map_bounds = false

signal out_of_map_bounds
signal dead
signal        hit (collision: KinematicCollision3D, delta:float)
signal   wall_hit (collision: KinematicCollision3D, delta:float, collider:Wall)
signal paddle_hit (collision: KinematicCollision3D, delta:float, collider:Paddle)
signal  brick_hit (collision: KinematicCollision3D, delta:float, collider:Brick)
signal   ball_hit (collision: KinematicCollision3D, delta:float, collider:Ball)

func move_forward(DeltaTime:float) -> KinematicCollision3D:
	return move_and_collide(dir * speed * DeltaTime)

func _physics_process(delta:float):
	var collision = move_forward(delta)
	
	if collision:
		hit.emit(collision, delta)
		
		var collider = collision.get_collider()
		
		if   collider is Brick:
			brick_hit.emit(collision, delta, collider)
		elif collider is Wall:
			wall_hit.emit(collision, delta, collider)
		elif collider is Paddle:
			paddle_hit.emit(collision, delta, collider)
		elif collider is Ball:
			ball_hit.emit(collision, delta, collider)

func _on_out_of_map_bounds() -> void:
	if respawn_when_out_of_map_bounds or Game.CountBalls() == 1:
		Game.SpawnBall()
	
	dead.emit()

func _on_dead() -> void:
	queue_free()

func _on_hit(collision: KinematicCollision3D, delta:float) -> void:
	Game.SillyFreeze(0.05)
	$"Parry-ultrakill".play()
	dir = dir.bounce(collision.get_normal())
	# Tencnically speeds it up but otherwise its clanky
	move_forward(delta * 2)

func _on_brick_hit(collision: KinematicCollision3D, delta:float, collider: Brick) -> void:
	collider.destroy()
	Game.SillyFreeze()
	$Destroy8PkWymg.play()
	Game.SpawnBall()

func _on_wall_hit(collision: KinematicCollision3D, delta:float, collider: Wall) -> void:
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

func _on_paddle_hit(collision: KinematicCollision3D, delta:float, collider: Paddle) -> void:
	print([
		'ping',
		'pong',
	].pick_random())


func _on_ball_hit(collision: KinematicCollision3D, delta: float, collider: Ball) -> void:
	pass
