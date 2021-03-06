extends Node

var current_state = null
var next_state = null 
var last_state = null 
			
			
var state_dict = { 
		
				}
				
var war_state_dict = {
	"idle" : preload("res://world/mobiles/base_mobile/states/base_idle.gd").new(),
	"fall" : preload("res://world/mobiles/base_mobile/states/base_fall.gd").new(),
	"patrol" : preload("res://world/mobiles/base_mobile/states/base_patrol.gd").new(),
	"pursue" : preload("res://world/mobiles/base_mobile/states/base_pursue.gd").new(),
	"reposition" : preload("res://world/mobiles/base_mobile/states/base_reposition.gd").new(),
	"warcry" : preload("res://world/mobiles/base_mobile/states/base_warcry.gd").new(),
	"defend" : preload("res://world/mobiles/base_mobile/states/base_defend_state.gd").new(),
	"circle" : preload("res://world/mobiles/base_mobile/states/base_circle.gd").new(),
	"attack" : preload("res://world/mobiles/base_mobile/states/base_attack_state.gd").new(),
	"delay" : preload("res://world/mobiles/base_mobile/states/base_delay.gd").new(),
	"stagger" : preload("res://world/mobiles/base_mobile/states/base_stagger_state.gd").new()
}

var peace_state_dict = {
	"idle" : preload("res://world/mobiles/base_mobile/states/base_idle.gd").new(),
	"fall" : preload("res://world/mobiles/base_mobile/states/base_fall.gd").new(),
	"patrol" : preload("res://world/mobiles/base_mobile/states/base_patrol.gd").new(),
	"pursue" : preload("res://world/mobiles/base_mobile/states/base_pursue.gd").new(),
	"reposition" : preload("res://world/mobiles/base_mobile/states/base_reposition.gd").new(),
	"warcry" : preload("res://world/mobiles/base_mobile/states/base_warcry.gd").new(),
	"defend" : preload("res://world/mobiles/base_mobile/states/base_defend_state.gd").new(),
	"circle" : preload("res://world/mobiles/base_mobile/states/base_circle.gd").new(),
	"attack" : preload("res://world/mobiles/base_mobile/states/base_attack_state.gd").new(),
	"delay" : preload("res://world/mobiles/base_mobile/states/base_delay.gd").new(),
	"stagger" : preload("res://world/mobiles/base_mobile/states/base_stagger_state.gd").new()
}
				
var override_dict = {}

onready var host = get_parent()
	
	
func _ready() -> void:
	state_dict = peace_state_dict
	instance_states()
	
	
func execute() -> void:
	cycle()
	
	
func set_state(index) -> void: #must take string or node
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
		#host.play(current_state.animation)
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
		#host.play(next_state.animation, true)
		host.npc("play", {animation=next_state.animation, motion=true})
	else:
		host.npc("play", {animation=next_state.animation, motion=false})
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
	return get_state("patrol")
	
	
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
			
			
func set_mode_dict(mode:String, dict:Dictionary) -> void:
	match mode:
		"peace":
			peace_state_dict = dict.duplicate(true)
		"combat":
			war_state_dict = dict.duplicate(true)
			
			
func override_state(index:String, state:State):
	override_dict[index] = state
	state.host = host


func quit_state() -> void:
	if current_state:
		current_state.exit()
	current_state = null
	next_state = null
	#current_state = calc_fallback_state()
