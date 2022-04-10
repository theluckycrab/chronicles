extends Node

var state = {
				current = null,
				next = null,
				last = null,
			}
			
var stateDict = {
					"Idle" : PlayerStateIdle.new(),
					"Fall" : PlayerStateFall.new(),
					"Walk" : PlayerStateWalk.new()
				}
				
onready var host = get_parent()
				
func _ready():
	Create_Fallback_Children()
	
func _physics_process(_delta):
	Update_State_Display()
			
func Execute():
	if state.current:
		state.current.Execute()
		if state.current.canExit():
			state.current.Exit()
			state.current = null
	if !state.current:
		Fallback()
	if state.next:
		Set_State(state.next)
	pass
	
func Fallback():
	if state.next:
		return
	for i in stateDict:
		if stateDict[i].canEnter():
			state.next = stateDict[i]
			return
	state.next = null
	
func Set_State(newState):
	newState.host = host
	if !newState or !newState.canEnter():
		return
	if state.current:
		if newState.priority < state.current.priority:
			return
		state.current.Exit()
	state.current = newState
	state.current.Enter()
	if state.current.animation:
		host.Animate(state.current.animation)
	state.next = null
	pass

func Reset():
	state.next = null
	Fallback()
	pass
	
func Create_Fallback_Children():
	for i in stateDict:
		add_child(stateDict[i])
		stateDict[i].host = host
		
func Update_State_Display():
	if state.current:
		$StateDisplay/VBoxContainer/HBoxContainer/currentLabel.text = str(state.current.slot)
	else:
		$StateDisplay/VBoxContainer/HBoxContainer/currentLabel.text = "null"
	if state.next:
		$StateDisplay/VBoxContainer/HBoxContainer2/nextLabel.text = str(state.next.slot)
	else:
		$StateDisplay/VBoxContainer/HBoxContainer2/nextLabel.text = "null"
