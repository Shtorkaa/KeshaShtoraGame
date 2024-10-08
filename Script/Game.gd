extends Node

var DefaultGameVolume = -20
var BallsSpawnHeight = .5
var PickupsSpawnHeight = 1
var BallFather = preload("res://Objects/ball.tscn")
var CONTROLS_PRESSED = {
	'LEFT': false,
	'RIGHT': false,
}
@onready var Level = LoadLevel()

# TODO Scan directories for names instead if its possible
const LevelCodes = [
	'1',
]
const ItemCodes = [
	'cruncher',
]
const EffectCodes = [
	'speed',
	'paddle_boost',
]

# GENERAL

func Round(Number:float, Digit:int) -> float:
	return round(Number * pow(10.0, Digit)) / pow(10.0, Digit)

func Random(Min:int = 0, Max:int = 100) -> int:
	return randi() % (Max - Min + 1) + Min

func Proc(Chance:float = 50) -> bool:
	return Random() < Chance

# GODOT

func SetGeneralVolume(Value:float = DefaultGameVolume):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), Value)

# GAMEPLAY

func SillyFreeze(TimeScale:float = 0.02):
	Engine.time_scale = TimeScale
	var SillyFreezeTimer = get_tree().create_timer(0.02)
	await SillyFreezeTimer.timeout
	Engine.time_scale = 1

func SpawnBall(Position:Vector3 = Vector3.ZERO, Direction:Vector3 = -Vector3.FORWARD, BaseSpeed:float = -1):
	var NewBall = BallFather.instantiate()
	
	NewBall.position = Position
	NewBall.position.y = BallsSpawnHeight
	NewBall.dir = Direction
	if BaseSpeed >= 0:
		NewBall.speed.set_base_value(BaseSpeed)
	
	add_child(NewBall)

func SpawnPickup(Position:Vector3 = Vector3.ZERO, PickupCode:String = ItemCodes.pick_random()):
	var PickupScene = load("res://Objects/Pickups/pickup_" + PickupCode + ".tscn")
	if !PickupScene: return
	
	var NewPickup = PickupScene.instantiate()
	
	NewPickup.position = Position
	NewPickup.position.y = PickupsSpawnHeight
	
	add_child(NewPickup)

func ClearLevel():
	for Child in get_children():
		Child.queue_free()

func LoadLevel(LevelCode:String = LevelCodes.pick_random()):
	var LevelScene = load("res://Scenes/Levels/Level_" + LevelCode + ".tscn")
	if !LevelScene: return
	
	ClearLevel()
	
	Level = LevelScene.instantiate()
	
	Level.name = 'Level'
	Level.position.z += 12.0
	
	add_child(Level)
	
	SpawnBall()
	
	return Level

func GetEffect(EffectCode:String = EffectCodes.pick_random()):
	var EffectScene = load("res://Objects/Effects/effect_" + EffectCode + ".tscn")
	if !EffectScene: return
	return EffectScene.instantiate()

func ApplyEffect(EffectCode:String = EffectCodes.pick_random()):
	# TODO Optimize (Check todo list)
	for Child in get_children():
		if not Child is Ball: continue
		Child.apply(EffectCode)

# SILLY CHECKS

func IsLevelCleared():
	if !Level: return true
	
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

func BallsEndedCheck():
	if CountBalls() < 1: SpawnBall()

# GODOT FUNCTIONS

func _input(Event:InputEvent):
	# Not sure if it could be optimised more
	if not Event.is_pressed() and not Event.is_released(): return
	
	# Better approach would be to check (in the passed Event arg) which action was just pressed / unpressed instead of looping through them all
	for CONTROLS_NAME in CONTROLS_PRESSED:
		if Input.is_action_just_pressed(CONTROLS_NAME):
			CONTROLS_PRESSED[CONTROLS_NAME] = true
		elif Input.is_action_just_released(CONTROLS_NAME):
			CONTROLS_PRESSED[CONTROLS_NAME] = false

func test():
	print('Hi, Im Peter Griffin')

func _ready() -> void:
	SetGeneralVolume()
	
	#var FunnySpeed = ModifiableFloat.new(10, 0, 100, Callable(self, 'test'), 2)
	#
	#FunnySpeed.set_modifier('boots', 8)
	#FunnySpeed.set_modifier('haste_rune', 52.96, ModifiableFloat.operations.percent)
	#FunnySpeed.set_modifier('slowing_mud', -25, ModifiableFloat.operations.percent)
	#FunnySpeed.set_modifier('strong_debuff', 6, ModifiableFloat.operations.fixed, true)
	#
	#Game.ApplyEffect()
