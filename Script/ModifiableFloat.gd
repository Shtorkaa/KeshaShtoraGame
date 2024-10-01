class_name ModifiableFloat extends Node

var      value:float
var  min_value:float
var  max_value:float
var base_value:float
var     modifiers:Dictionary = {}
var modifications:Dictionary = {}
const  operations:Dictionary = {
	'add': 'ADDITION',
	'percent': 'PERCENTAGES',
	'fixed': 'FIXED_VALUE',
	'round': 'ROUND',
}

signal update

func _init(base:float = 0.0, min:float = -1.7976931348623157e+308, max:float = 1.7976931348623157e+308, on_update:Callable = Callable()) -> void:
	set_min_value(min)
	set_max_value(max)
	set_base_value(base)
	if on_update: update.connect(on_update)

func set_max_value(new_max_value:float) -> void:
	max_value = new_max_value
	clamp_value()
	
func set_min_value(new_min_value:float) -> void:
	min_value = new_min_value
	clamp_value()

func set_base_value(new_base_value:float) -> void:
	base_value = new_base_value
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
	print(' -> ', value)
	update.emit()

func update_value() -> void:
	value = base_value
	modifications = {
		# NOTE Operations are performed top to bottom
		operations.fixed: null,
		operations.add: 0.0,
		operations.percent: 100.0,
		operations.round: null,
	}
	
	print(modifiers)
	
	for modifier in modifiers.values():
		match modifier.operation:
			operations.fixed:
				modifications[modifier.operation] = modifier.value
			operations.round:
				modifications[modifier.operation] = int(modifier.value)
			_:
				modifications[modifier.operation] += modifier.value
		
	print(modifications, ', ', value)
	
	for modification_type in modifications.keys():
		var modification_value = modifications[modification_type]
		if modification_value == null: continue
		match modification_type:
			operations.fixed:
				value = modification_value
				break
			operations.add:
				value += modification_value
			operations.percent:
				value = value / 100 * modification_value
			operations.round:
				value = round(value * pow(10.0, modification_value)) / pow(10.0, modification_value)
		print(modification_type, ' ', modification_value, ' -> ', value)
	
	clamp_value()
