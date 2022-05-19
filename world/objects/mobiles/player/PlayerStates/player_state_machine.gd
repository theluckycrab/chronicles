extends Node

var current_state = null
var next_state = null 
var last_state = null 
			
			
var base_state_dict = {
					"idle" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_idle.gd").new(),
					"fall" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_fall.gd").new(),
					"walk" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_walk.gd").new(),
					"jump" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_jump.gd").new()
				}
				
var override_dict = {}

onready var host = get_parent()
				
				
func _ready() -> void:
	instance_states()
	
func execute() -> void:
	cycle()
	pass
	
func set_state(index):
	if get_state(index) == null:
		return
		
	var cprior
	var nprior = get_state(index).priority
	if current_state == null:
		cprior = 0
	else:
		cprior = get_state(current_state).priority
	
	if nprior > cprior:
		next_state = get_state(index)
	
	
func cycle() -> void:
	if current_state == null:
		current_state = calc_fallback_state()
		current_state.enter()
		host.anim.play(current_state.animation)
	current_state.execute()
	
	if current_state.can_exit():
		current_state.exit()
		current_state = null
	
	if next_state == null or next_state.can_enter() == false:
		next_state = null
		return
	
	if current_state:
		current_state.exit()
	next_state.enter()
	current_state = next_state
	next_state = null
	return
	
func instance_states() -> void:
	for i in base_state_dict:
		add_child(base_state_dict[i])
		base_state_dict[i].host = host
		

func calc_fallback_state():
	if current_state != null:
		return
	if ! host.is_on_floor():
		return get_state("fall")
	if host.is_on_floor() and host.velocity.controlled == Vector3.ZERO:
		return get_state("idle")
	if host.is_on_floor():
		return get_state("walk")
		
		
func get_state(index=null):
	if index is String:
		if override_dict.has(index):
			return override_dict[index]
		elif base_state_dict.has(index):
			return base_state_dict[index]
		else:
			return null
	elif index is State:
		return index
	else:
		return current_state
				
	
		
func update_state_display() -> void:
	if current_state:
		$StateDisplay/VBoxContainer/HBoxContainer/CurrentLabel.text = str(current_state.index)
	else:
		$StateDisplay/VBoxContainer/HBoxContainer/CurrentLabel.text = "null"
	if next_state:
		$StateDisplay/VBoxContainer/HBoxContainer2/NextLabel.text = str(next_state.index)
	else:
		$StateDisplay/VBoxContainer/HBoxContainer2/NextLabel.text = "null"
