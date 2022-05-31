extends Node

var current_state = null
var next_state = null 
var last_state = null 
			
			
var state_dict = {
				}
				
var war_state_dict = {
		"idle" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_idle.gd").new(),
		"fall" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_fall.gd").new(),
		"walk" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_walk.gd").new(),
		"jump" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_jump.gd").new(),
		"draw" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_draw.gd").new(),
		"light_attack" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_light_attack.gd").new(),
		"strong_attack" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_strong_attack.gd").new(),
		"guard" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_guard.gd").new(),
		"dodge" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_dodge.gd").new(),
		"falling_attack" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_falling_attack.gd").new(),
		"dodge_attack" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_dodge_attack.gd").new()
}

var peace_state_dict = {
		"idle" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_idle.gd").new(),
		"fall" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_fall.gd").new(),
		"walk" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_walk.gd").new(),
		"jump" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_jump.gd").new(),
		"draw" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_draw.gd").new(),
}
				
var override_dict = {}

onready var host = get_parent()
	
	
func _ready() -> void:
	state_dict = peace_state_dict
	instance_states()
	
	
func execute() -> void:
	state_controls()
	update_state_display()
	cycle()
	
	
func set_state(index:String) -> void:
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
		host.play(current_state.animation)
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
	host.play(next_state.animation)
	current_state = next_state
	next_state = null
	return
	
	
func instance_states() -> void:
	for i in peace_state_dict:
		add_child(peace_state_dict[i])
		peace_state_dict[i].host = host
	for i in war_state_dict:
		add_child(war_state_dict[i])
		war_state_dict[i].host = host
		

func calc_fallback_state():
	if current_state != null:
		return
	if ! host.is_on_floor():
		return get_state("fall")
	if host.is_on_floor() and host.get_wasd() == Vector3.ZERO or !host.can_act:
		return get_state("idle")
	if host.is_on_floor() and host.get_wasd() != Vector3.ZERO:
		return get_state("walk")
	return get_state("idle")
	
	
func get_state(index=null):#string or node
	if index is String:
		if override_dict.has(index):
			return override_dict[index]
		elif state_dict.has(index):
			return state_dict[index]
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
	if host.in_combat:
		$StateDisplay/VBoxContainer/HBoxContainer3/WarLabel.text = "WAR"
	else:
		$StateDisplay/VBoxContainer/HBoxContainer3/WarLabel.text = "PEACE"
	if host.lock_target:
		$StateDisplay/VBoxContainer/HBoxContainer4/TargetLabel.text = host.lock_target.name
	else:
		$StateDisplay/VBoxContainer/HBoxContainer4/TargetLabel.text = "null"


func set_mode(mode:String) -> void:
	match mode:
		"peace":
			state_dict = peace_state_dict
		"combat":
			state_dict = war_state_dict


func quit_state() -> void:
	if current_state:
		current_state.exit()
	current_state = null
	next_state = null
	current_state = calc_fallback_state()


func state_controls():
	if !host.can_act or host.ui_active():
		return
	for i in state_dict:
		if InputMap.has_action(i):
			if Input.is_action_just_pressed(i):
				set_state(i)
				return
