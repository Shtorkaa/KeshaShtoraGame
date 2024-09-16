extends Node

var CONTROLS_PRESSED = {
	'LEFT': false,
	'RIGHT': false,
}

var BallFather = preload("res://Objects/ball.tscn")

# Would be easier to scan the Levels directory for names
var LevelCodes = [
	'1',
	'2',
]


# Helpers

func Round(Number:float, Digit:int = 0):
	# Godot doesnt provide a func to round to a specific digit after the floating point
	return round(Number * pow(10.0, Digit)) / pow(10.0, Digit)

# Silly helpers

func Error(Message:String):
	# printerr('ERROR: ' + Message)
	push_error(Message)
	return false

# Base game

func SillyFreeze(TimeScale:float = 0.02):
	return
	Engine.time_scale = TimeScale
	var SillyFreezeTimer = get_tree().create_timer(0.02)
	await SillyFreezeTimer.timeout
	Engine.time_scale = 1

func SpawnBall(Position:Vector3 = Vector3.ZERO, Direction:Vector3 = Vector3.FORWARD, Speed:float = 8.0):
	var NewBall = BallFather.instantiate()
	
	NewBall.position = Position
	NewBall.position.y = 0.5
	NewBall.dir = Direction
	NewBall.speed = Speed
	
	add_child(NewBall)

func ClearLevel():
	for Child in get_children():
		Child.queue_free()

func LoadLevel(LevelCode:String = LevelCodes.pick_random()):
	# Could also scan LevelCodes instead
	var LevelPath = "res://Scenes/Levels/" + LevelCode + ".tscn"
	var Level = load(LevelPath)
	
	if !Level: return Error('Couldnt find ' + LevelPath)
	
	ClearLevel()
	
	var NewLevel = Level.instantiate()
	
	NewLevel.name = 'Level'
	NewLevel.position.z += 5.0
	
	add_child(NewLevel)
	
	SpawnBall()

func IsLevelCleared():
	var Level = get_node('Level')
	if !Level: return !Error('Couldnt find level child node, perhaps it was not created or was saved under a wrong name.')
	
	if Level.get_children().size() > 0: return false
	else: return true

func CountBalls() -> int:
	# A better way would be to store all the balls by one path
	var Count = 0
	for GameElement in get_children():
		if GameElement is Ball:
			Count += 1
	return Count

func _input(Event:InputEvent):
	# Not sure how it could be optimised more
	if not Event.is_pressed() and not Event.is_released(): return
	
	# Better approach would be to check (in the passed Event arg) which action was just pressed / unpressed instead of looping through them all
	for CONTROLS_NAME in CONTROLS_PRESSED:
		if Input.is_action_just_pressed(CONTROLS_NAME):
			CONTROLS_PRESSED[CONTROLS_NAME] = true
		elif Input.is_action_just_released(CONTROLS_NAME):
			CONTROLS_PRESSED[CONTROLS_NAME] = false

func _process(DeltaTime:float) -> void:
	
	if IsLevelCleared():
		LoadLevel()
