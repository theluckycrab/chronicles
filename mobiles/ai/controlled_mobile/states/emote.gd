extends State

var animation: String
var held: bool = true

func _init() -> void:
	priority = 2
	index = "Emote"

func can_enter() -> bool:
	return true
	
func can_exit() -> bool:
	if ! held:
		return ! host.armature.is_using_root_motion()
	else:
		return host.ai.get_wasd() != Vector3.ZERO

func enter() -> void:
	if ! held:
		host.play(animation, true)
		
func execute() -> void:
	if held:
		host.play(animation)
	
func exit() -> void:
	pass
	

