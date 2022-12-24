extends Node
class_name StateMachine

var current_state = null
var next_state = null
var last_state = null

var override_dictionary = {}

onready var walk = $Walk

onready var host = get_parent()

func cycle():
	fallback()
	if is_instance_valid(next_state):
		if next_state.can_enter() and \
			(next_state.priority > current_state.priority or current_state.can_exit()):
			current_state.exit()
			next_state.enter()
			last_state = current_state
			current_state = next_state
			next_state = null
	current_state.execute(host)
	pass

func set_state(state):
	if state is String:
		next_state = get_state(state)
	elif state is State:
		next_state = state
		
func get_state(state:String):
	if override_dictionary.has(state):
		return override_dictionary[state]
	else:
		return get_node_or_null(state)

func add_override(key:String, value):
	override_dictionary[key] = value
	add_child(value)
	
func remove_override(key:String):
	if override_dictionary.has(key) and is_instance_valid(override_dictionary[key]):
		var s = override_dictionary[key]
		if current_state == s:
			current_state = null
		if next_state == s:
			next_state = null
		remove_child(override_dictionary[key])
	override_dictionary.erase(key)
	
func fallback():
	if ! is_instance_valid(current_state):
		current_state = get_state("Walk")
