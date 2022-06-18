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
		"draw" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_sheathe.gd").new(),
		"light_attack" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_light_attack.gd").new(),
		"strong_attack" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_strong_attack.gd").new(),
		"guard" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_guard.gd").new(),
		"dodge" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_dodge.gd").new(),
		"dash" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_dash.gd").new(),
		"falling_attack" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_falling_attack.gd").new(),
		"stagger" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_stagger.gd").new(),
		"dodge_attack" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_dodge_attack.gd").new(),
		"interact" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_interact.gd").new(),
		"equip" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_equip.gd").new(),
}

var peace_state_dict = {
		"idle" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_idle.gd").new(),
		"fall" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_fall.gd").new(),
		"walk" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_walk.gd").new(),
		"jump" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_jump.gd").new(),
		"draw" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_draw.gd").new(),
		"stagger" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_stagger.gd").new(),
		"interact" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_interact.gd").new(),
		"equip" : preload("res://world/objects/mobiles/player/PlayerStates/player_state_equip.gd").new(),
}
				
var override_dict = {}

onready var host = get_parent()
	
	
func _ready() -> void:
	state_dict = peace_state_dict
	instance_states()
	
	
func execute() -> void:
	state_controls()
	cycle()
	
	
func set_state(index) -> void:
	if get_state(index) == null:
		return
	var cprior
	var nprior = get_state(index).priority
	if current_state == null:
		cprior = 0
	else:
		cprior = get_state(current_state).priority
		
	if nprior >= cprior:
		next_state = get_state(index)
		
	
func cycle() -> void:
	if current_state == null:
		current_state = calc_fallback_state()
		current_state.enter()
		host.npc("play", {animation=current_state.animation, motion=false})
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
	if next_state is ActionState:
		host.npc("play", {animation=next_state.animation, motion=true})
		#host.play(next_state.animation, true)
	else:
		host.npc("play", {animation=next_state.animation, motion=false})
		#host.play(next_state.animation)
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
	if is_instance_valid(host.lock_target) and Input.is_action_just_pressed("switch_target"):
		host.acquire_lock_target(host.lock_target)
		return
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	for i in state_dict:
		if ["interact"].has(i):
			return
		if InputMap.has_action(i):
			if Input.is_action_just_pressed(i):
				set_state(i)
				return
				
