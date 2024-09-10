extends Node

var CONTROLS_PRESSED = {
	'LEFT': false,
	'RIGHT': false,
}

func _input(Event: InputEvent):
	# Not sure how it could be optimised more
	if not Event.is_pressed() and not Event.is_released(): return
	
	# Better approach would be to check (in the passed Event arg) which action was just pressed / unpressed instead of looping through all
	for CONTROLS_NAME in CONTROLS_PRESSED:
		if Input.is_action_just_pressed(CONTROLS_NAME):
			CONTROLS_PRESSED[CONTROLS_NAME] = true
		elif Input.is_action_just_released(CONTROLS_NAME):
			CONTROLS_PRESSED[CONTROLS_NAME] = false
