extends Node
class_name StateMachine

signal state_changed

var current_state = null
var next_state = null
var last_state = null

var override_dictionary = {}

onready var host = get_parent()

func _ready():
	for i in get_children():
		i.host = host

func cycle():
	if is_instance_valid(current_state): #if we are in a state
		if is_instance_valid(next_state): #see if we have a new state
			if next_state.can_enter() \
				and (current_state.can_exit() \
				or next_state.priority > current_state.priority): #if we can enter that new state
					current_state.exit()						#and we can exit or higher p
					next_state.enter()
					current_state = next_state					#exit old enter new
			next_state = null
		elif !is_instance_valid(next_state):
			if current_state.can_exit(): #if we don't have a new state
				current_state.exit() #check if we can exit the current state
				current_state = null #exit it and fallback
				fallback()
				return
	elif !is_instance_valid(current_state):
		if is_instance_valid(next_state):
			if next_state.can_enter():
				next_state.enter()
				current_state = next_state
				next_state = null
		else:
			fallback()
			return
	emit_signal("state_changed", current_state.index)
	current_state.execute()
	pass

func set_state(state):
	if state is String:
		next_state = get_state(state)
	elif state is State:
		next_state = state
	if is_instance_valid(next_state):
		next_state.host = host
	cycle()
		
func get_state(state:String):
	if override_dictionary.has(state):
		return override_dictionary[state]
	else:
		return get_node_or_null(state)

func add_override(key:String, value):
	override_dictionary[key] = value
	value.host = host
	add_child(value)
	
func remove_override(key:String):
	if override_dictionary.has(key) and is_instance_valid(override_dictionary[key]):
		var s = override_dictionary[key]
		if current_state == s:
			current_state.exit()
			current_state = null
			fallback()
		if next_state == s:
			next_state = null
		remove_child(override_dictionary[key])
	override_dictionary.erase(key)
	
func fallback():
	if ! is_instance_valid(current_state):
		for i in ["Fall", "Walk", "Idle"]:
			if get_state(i).can_enter():
				set_state(get_state(i))
				return
		print("couldn't find a fallback state for ", get_parent())
