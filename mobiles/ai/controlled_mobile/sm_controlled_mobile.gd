extends StateMachine

"""
	The Controlled state machine is meant to provide functionality for a basic playable character. 
		It needs to respond to inputs and switch to relevant states. A portion of this is going to 
		be calling into the mobile class to use functions that will ultimately call right back. To
		keep mobiles generic, no actual input should be processed on the mobile script.
		
	Dependencies : ControlledCamera, Events
"""

var interfaces = [IController.new(self)]
var input_locks = 0
onready var camera = $ControlledCamera
onready var state_label = $Label

var wasd: Vector3 = Vector3.ZERO

func _ready():
	var _dis = Events.connect("ui_opened", self, "change_input_locks", [1])
	var _card = Events.connect("ui_closed", self, "change_input_locks", [-1])
	
func change_input_locks(c: int):
	input_locks += c

func get_wasd() -> Vector3:
	return wasd
	
func get_wasd_cam() -> Vector3:
	return get_wasd().normalized().rotated(Vector3.UP, camera.rotation.y)
	
func _process(_delta):
	if is_instance_valid(current_state):
		state_label.text = current_state.index
	else:
		state_label.text = "No State"

func _unhandled_input(event):
	wasd = Vector3.ZERO
	if !can_act():
		return
	if event.is_action("jump") and ! event.is_echo():
		set_state("Jump")
	wasd.x = Input.get_action_strength("a") - Input.get_action_strength("d")
	wasd.z = Input.get_action_strength("w") - Input.get_action_strength("s")

func can_act() -> bool:
	return input_locks == 0
