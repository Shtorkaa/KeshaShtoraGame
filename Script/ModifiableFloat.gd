class_name ModifiableFloat extends Node

var      value:float
var  min_value:float
var  max_value:float
var base_value:float
var   truncate:int
const  operations:Dictionary = {
	# NOTE Operations are performed top to bottom
	'add': 'ADDITION',
	'percent': 'PERCENTAGES',
	'fixed': 'FIXED_VALUE',
}
var     modifiers:Dictionary = {}
var modifications:Dictionary = {}
var modifications_base_values:Dictionary = {
	operations.add: 0.0,
	operations.percent: 100.0,
}

signal update

func _init(base:float = 0.0, min:float = -1.7976931348623157e+308, max:float = 1.7976931348623157e+308, on_update:Callable = Callable(), cut_digits:int = -1) -> void:
	set_truncate_value(cut_digits)
	set_min_value(min)
	set_max_value(max)
	set_base_value(base)
	if on_update: update.connect(on_update)
	print('NEW COMPLEX NUMBER WAS INIT')

func set_max_value(new_max_value:float) -> void:
	max_value = new_max_value
	clamp_value()
	
func set_min_value(new_min_value:float) -> void:
	min_value = new_min_value
	clamp_value()

func set_base_value(new_base_value:float) -> void:
	base_value = new_base_value
	update_value()
	
func set_truncate_value(new_truncate_value:int) -> void:
	truncate = new_truncate_value
	update_value()

func set_modifier(id:String, number:float, operation:String = operations.add) -> void:
	if not operation in operations.values():
		push_error('Couldnt determine a modifier operation')
		return
	modifiers[id] = { 'value': number, 'operation': operation, }
	update_value()

func remove_modifier(id:String):
	modifiers.erase(id)
	update_value()

func clamp_value(debug: bool = false):
	value = clamp(value, min_value, max_value)
	if debug: print('CLAMPED WITHIN ', min_value, ' - ', max_value, ' -> ', value)
	truncate_value(debug)

func truncate_value(debug: bool = false):
	if truncate >= 0:
		# Some voodoo magic going on here
		var factor = pow(10, truncate)
		value = floor(value * factor) / factor
	if debug: print('TRUNCATING BY ', truncate, ' -> ', value)
	
	if debug: print(' -> ', value)
	update.emit()

func calc_modifiers(debug: bool = false):
	if debug: print(' CALCULATING MODIFICATIONS *')
	
	var new_modifications = {}
	
	# Calc modification new values
	for modifier in modifiers.values():
		if debug: print('  ', modifier)
		
		# Set modification value to base value if they have one
		if (modifier.operation in modifications_base_values.keys() and
			not modifier.operation in new_modifications):
				new_modifications[modifier.operation] = modifications_base_values[modifier.operation]
		
		# Perform the calcs based on operation
		match modifier.operation:
			# NOTE This part bit complex
			operations.fixed:
				new_modifications[modifier.operation] = modifier.value
			_:
				new_modifications[modifier.operation] += modifier.value
	
	if debug: print('  ', new_modifications)
	
	modifications = new_modifications

func update_value(debug: bool = false) -> void:
	if debug: print('UPDATING VALUE')
	
	calc_modifiers(debug)
	
	var new_value = base_value
	if debug: print(' RESET TO BASE VALUE ', value, ' -> ', new_value)
	
	if debug: print(' APPLYING MODIFICATIONS **')
	for modification_type in modifications.keys():
		var modification_value = modifications[modification_type]
		if modification_value == null: continue
		match modification_type:
			operations.fixed:
				new_value = modification_value
				break
			operations.add:
				new_value += modification_value
			operations.percent:
				new_value = new_value / 100 * modification_value
		
		if debug: print('  ', modification_type, ' ', modification_value, ' -> ', new_value)
	
	if debug: print(' UPDATED VALUE ', value, ' -> ', new_value)
	value = new_value
	clamp_value(debug)
