extends Node

var CONTROLS_PRESSED = {
	'LEFT': false,
	'RIGHT': false,
}

var ItemsFixedHeightSpwnThing = .5

var BallFather = preload("res://Objects/ball.tscn")

var Level

# TODO Scan directories for names instead ?
var LevelCodes = [
	'1',
]
var ItemCodes = [
	'cruncher'
]

func Round(Number:float, Digit:int = 0) -> float:
	# Godot doesnt provide a func to round to a specific digit after the floating point
	return round(Number * pow(10.0, Digit)) / pow(10.0, Digit)

func Random(Min:int = 0, Max:int = 100) -> int:
	return randi() % (Max - Min + 1) + Min

func Proc(Chance:float = 50) -> bool:
	return Random() > 50

func SillyFreeze(TimeScale:float = 0.02):
	Engine.time_scale = TimeScale
	var SillyFreezeTimer = get_tree().create_timer(0.02)
	await SillyFreezeTimer.timeout
	Engine.time_scale = 1

func SpawnBall(Position:Vector3 = Vector3.ZERO, Direction:Vector3 = Vector3.FORWARD, Speed:float = 8.0):
	var NewBall = BallFather.instantiate()
	
	NewBall.position = Position
	NewBall.position.y = ItemsFixedHeightSpwnThing
	NewBall.dir = Direction
	NewBall.speed = Speed
	
	add_child(NewBall)

func SpawnPickup(Position:Vector3 = Vector3.ZERO, PickupCode:String = ItemCodes.pick_random()):
	var PickupScene = load("res://Objects/Pickups/pickup_" + PickupCode + ".tscn")
	if !PickupScene: return
	
	var NewPickup = PickupScene.instantiate()
	
	NewPickup.position = Position
	NewPickup.position.y = ItemsFixedHeightSpwnThing
	
	add_child(NewPickup)

func ClearLevel():
	for Child in get_children():
		Child.queue_free()

func LoadLevel(LevelCode:String = LevelCodes.pick_random()):
	var LevelScene = load("res://Scenes/Levels/" + LevelCode + ".tscn")
	if !LevelScene: return
	
	ClearLevel()
	
	Level = LevelScene.instantiate()
	
	Level.name = 'Level'
	Level.position.z += 12.0
	
	add_child(Level)
	
	SpawnBall()

func IsLevelCleared():
	if !Level:
		return true
	
	for LevelElement in Level.get_children():
		if LevelElement is Brick and LevelElement.is_dead == false:
			return false
	
	return true

func LevelFinishCheck():
	if IsLevelCleared():
		LoadLevel()

func CountBalls() -> int:
	# A better way would be to store all the balls by one path
	var Count = 0
	for GameElement in get_children():
		if GameElement is Ball and GameElement.is_dead == false: # Only counts alive balls
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
