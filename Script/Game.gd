extends Node

var CONTROLS_PRESSED = {
	'LEFT': false,
	'RIGHT': false,
}

var BallFather = preload("res://Objects/ball.tscn")
@onready var BallSchool = $"."

# Helpers

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)

# Base game

func SillyFreeze(TimeScale:float = 0.02):
	Engine.time_scale = TimeScale
	var SillyFreezeTimer = get_tree().create_timer(0.02)
	await SillyFreezeTimer.timeout
	Engine.time_scale = 1

func SpawnBall(Position:Vector3 = Vector3.ZERO, Direction:Vector3 = Vector3.FORWARD, Speed:float = 8.0):
	var NewBall = BallFather.instantiate()
	
	NewBall.position = Position
	NewBall.dir = Direction
	NewBall.speed = Speed
	
	BallSchool.add_child(NewBall)

func _input(Event: InputEvent):
	# Not sure how it could be optimised more
	if not Event.is_pressed() and not Event.is_released(): return
	
	# Better approach would be to check (in the passed Event arg) which action was just pressed / unpressed instead of looping through them all
	for CONTROLS_NAME in CONTROLS_PRESSED:
		if Input.is_action_just_pressed(CONTROLS_NAME):
			CONTROLS_PRESSED[CONTROLS_NAME] = true
		elif Input.is_action_just_released(CONTROLS_NAME):
			CONTROLS_PRESSED[CONTROLS_NAME] = false
