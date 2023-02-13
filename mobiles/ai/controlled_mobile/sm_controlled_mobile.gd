extends StateMachine

"""
	The Controlled state machine is meant to provide functionality for a basic playable character. 
		It needs to respond to inputs and switch to relevant states. A portion of this is going to 
		be calling into the mobile class to use functions that will ultimately call right back. To
		keep mobiles generic, no actual input should be processed on the mobile script.
		
	Dependencies : ControlledCamera
"""

var interfaces = [IController.new(self)]
onready var camera = $ControlledCamera
onready var state_label = $Label

func get_wasd() -> Vector3:
	var wasd = Vector3.ZERO
	wasd.x = Input.get_action_strength("a") - Input.get_action_strength("d")
	wasd.z = Input.get_action_strength("w") - Input.get_action_strength("s")
	return wasd
	
func get_wasd_cam() -> Vector3:
	return get_wasd().normalized().rotated(Vector3.UP, camera.rotation.y)
	
func _process(_delta):
	if is_instance_valid(current_state):
		state_label.text = current_state.index
	else:
		state_label.text = "No State"
	if Input.is_action_just_pressed("ui_accept"):
		set_state("Jump")
