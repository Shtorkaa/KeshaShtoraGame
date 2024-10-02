class_name ModifiableFloat extends Node

var      value:float
var  min_value:float
var  max_value:float
var base_value:float
var   truncate:int
var     modifiers:Dictionary = {}
var modifications:Dictionary = {}
const  operations:Dictionary = {
	'add': 'ADDITION',
	'percent': 'PERCENTAGES',
	'fixed': 'FIXED_VALUE',
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

func clamp_value():
	value = clamp(value, min_value, max_value)
	print('CLAMPED BETWEEN ', min_value, ' AND ', max_value)
	truncate_value()

func truncate_value():
	if truncate >= 0:
		# Some voodoo magic going on here
		var factor = pow(10, truncate)
		value = floor(value * factor) / factor
	print('TRUNCATE TO ', truncate)
	print(' -> ', value)
	update.emit()

func update_value() -> void:
	value = base_value
	modifications = {
		# NOTE Operations are performed top to bottom
		operations.fixed: null,
		operations.add: 0.0,
		operations.percent: 100.0,
	}
	
	print(modifiers)
	
	for modifier in modifiers.values():
		match modifier.operation:
			operations.fixed:
				modifications[modifier.operation] = modifier.value
			_:
				modifications[modifier.operation] += modifier.value
		
	print(modifications, ', ', value)
	
	for modification_type in modifications.keys():
		var modification_value = modifications[modification_type]
		# TODO OPTIMISE IT HERE SO THAT IT DOESNT DO modifications'S if their values are default ?
		if modification_value == null: continue
		match modification_type:
			operations.fixed:
				value = modification_value
				break
			operations.add:
				value += modification_value
			operations.percent:
				value = value / 100 * modification_value
		print(modification_type, ' ', modification_value, ' -> ', value)
	
	# NOTE Maybe its best not to proceed if the value was not changed actually
	clamp_value()
