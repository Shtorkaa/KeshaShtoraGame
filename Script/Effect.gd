class_name Effect extends Node3D

var default_duration = 5.0
var minimum_duration = 1.0
var maximum_duration = 60.0
var endtick_duration = 0.1
var exposed = true
var active = false
var one_shot = false
var is_dead = false

# WARNING All effects are required to be located by Ball/.../
@onready var ball = $"../.."

# WARNING Not a good fit for the use case
signal applied
signal cleared
signal shown
signal hidden

# TODO Rename to start
func start(duration:float = default_duration):
	print('Applied an effect')
	active = true
	if duration <= 0:
		duration = default_duration
	else:
		duration = clamp(duration, minimum_duration, maximum_duration)
	refresh(duration)
	applied.emit()
	expose(true)

func get_time_left() -> float:
	return $Duration.time_left

func refresh(new_duration:float = default_duration):
	if !active: return
	if get_time_left() > new_duration: return
	$Duration.wait_time = new_duration
	$Duration.start(0)
	$Ending.wait_time = new_duration - minimum_duration
	$Ending.start(0)
	$EndingTick.stop()

func clear():
	if !active: return
	print('Cleared an effect')
	active = false
	$Duration.stop()
	$Ending.stop()
	$EndingTick.stop()
	cleared.emit()
	expose(false)
	if one_shot: kill()

func expose(value:bool):
	if value == exposed: return
	
	exposed = value
	
	if exposed:
		shown.emit()
	else:
		hidden.emit()

func kill():
	if is_dead: return
	print('Effect killed')
	is_dead = true
	clear()
	$Afterlife.start()

func set_one_shot(value:bool):
	one_shot = value

func _ready():
	expose(false)

func _on_duration_timeout() -> void:
	print('Effect duration finished')
	clear()

func _on_ending_timeout() -> void:
	print('Effect duration ending')
	$EndingTick.wait_time = endtick_duration
	$EndingTick.start(0)

func _on_ending_tick_timeout() -> void:
	print('Effect duration ending fr!')
	expose(!exposed)
	$EndingTick.start(0)

func _on_afterlife_timeout() -> void:
	print('Effect completely removed')
	queue_free()
