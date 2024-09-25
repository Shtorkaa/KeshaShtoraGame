extends StaticBody3D
class_name Ball

var dir = Vector3.FORWARD
var speed = 12.0
var is_dead = false
var remove_on_death = [
	"Hitbox",
	"Model",
]

signal out_of_map_bounds
signal dead
signal        hit (collision: KinematicCollision3D, delta:float)
signal   wall_hit (collision: KinematicCollision3D, delta:float, collider:Wall)
signal paddle_hit (collision: KinematicCollision3D, delta:float, collider:Paddle)
signal  brick_hit (collision: KinematicCollision3D, delta:float, collider:Brick)
signal   ball_hit (collision: KinematicCollision3D, delta:float, collider:Ball)

func _physics_process(delta:float):
	if is_dead: return
	
	# NOTE If theres a signal that gives out a KinematicCollision3D use it instead of all this
	# NOTE I have no clue what was i talking about in the comment above
	var collision = move_and_collide(dir * speed * delta)
	if !collision: return
	
	var collider = collision.get_collider()
	
	hit.emit(collision, delta)
	
	if   collider is Brick:
		brick_hit.emit(collision, delta, collider)
	elif collider is Wall:
		wall_hit.emit(collision, delta, collider)
	elif collider is Paddle:
		paddle_hit.emit(collision, delta, collider)
	elif collider is Ball:
		ball_hit.emit(collision, delta, collider)

func _on_out_of_map_bounds() -> void:
	if Game.CountBalls() == 1:
		Game.SpawnBall()
	
	dead.emit()

func _on_dead() -> void:
	if is_dead: return
	is_dead = true
	for kid_full_name in remove_on_death:
		var kid = get_node(kid_full_name)
		if !kid: return
		kid.queue_free()
	$SoundDead.play()
	$Afterlife.start()

func _on_hit(collision: KinematicCollision3D, delta:float) -> void:
	if collision.get_collider() is Brick and collision.get_collider().is_dead: return 
	Game.SillyFreeze(0.05)
	$SoundHit.play()
	dir = dir.bounce(collision.get_normal())

func _on_brick_hit(collision: KinematicCollision3D, delta:float, collider: Brick) -> void:
	collider.destroy()
	Game.SillyFreeze()
	Game.SpawnBall()

func _on_wall_hit(collision: KinematicCollision3D, delta:float, collider: Wall) -> void:
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

func _on_paddle_hit(collision: KinematicCollision3D, delta:float, collider: Paddle) -> void:
	print(['Ping', 'Pong'].pick_random())

func _on_ball_hit(collision: KinematicCollision3D, delta: float, collider: Ball) -> void:
	collider.out_of_map_bounds.emit()

func _on_afterlife_timeout() -> void:
	queue_free()
