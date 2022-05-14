extends Node

var state = {
				current = null,
				next = null,
				last = null,
				string = ""
			}
			
var base_state_dict = {
					"Idle" : PlayerStateIdle.new(),
					"Fall" : PlayerStateFall.new(),
					"Walk" : PlayerStateWalk.new(),
					"Jump" : PlayerStateJump.new()
				}
				
var state_dict = base_state_dict.duplicate(true)

onready var host = get_parent()
				
				
func _ready() -> void:
	create_fallback_children()
	
	
func _physics_process(_delta) -> void:
	controls()
	update_state_display()
			
			
func execute() -> void:
	if state.current:
		state.current.execute()
		if state.current.can_exit():
			state.current.exit()
			state.current = null
	if !state.current:
		fallback()
	if state.next:
		set_state(state.next)
	pass
	
	
func fallback() -> void:
	if state.next:
		return
	for i in state_dict:
		if state_dict[i].can_enter():
			state.next = state_dict[i]
			return
	state.next = null
	
	
func set_state(new_state) -> void:
	new_state.host = host
	if !new_state or !new_state.can_enter():
		return
	if state.current:
		if new_state.priority < state.current.priority:
			return
		state.current.exit()
	state.current = new_state
	state.current.enter()
	if state.current.animation:
		host.animate(state.current.animation)
	state.next = null
	state.string = new_state.slot
	pass


func reset() -> void:
	state.next = null
	fallback()
	pass
	
	
func create_fallback_children() -> void:
	for i in state_dict:
		add_child(state_dict[i])
		state_dict[i].host = host
		
		
func update_state_display() -> void:
	if state.current:
		$StateDisplay/VBoxContainer/HBoxContainer/CurrentLabel.text = str(state.current.slot)
	else:
		$StateDisplay/VBoxContainer/HBoxContainer/CurrentLabel.text = "null"
	if state.next:
		$StateDisplay/VBoxContainer/HBoxContainer2/NextLabel.text = str(state.next.slot)
	else:
		$StateDisplay/VBoxContainer/HBoxContainer2/NextLabel.text = "null"


func controls() -> void:
	if Input.is_action_just_pressed("jump"):
		set_state(state_dict["Jump"])


func swap_state(slot:String, state_object:Node) -> void:
	state_object.host = host
	state_dict[slot] = state_object
	
	
func reset_state(slot:String) -> void:
	state_dict[slot] = base_state_dict[slot]

