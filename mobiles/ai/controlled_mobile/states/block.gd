extends State

var initial_velocity = 15
var current_velocity = initial_velocity
var friction = 0.1

func _init():
	priority = 3
	index = "Block"

func can_enter() -> bool:
	return true
	
func can_exit() -> bool:
	return ! Input.is_action_pressed("block")

func enter() -> void:
	pass
	
func exit() -> void:
	current_velocity = initial_velocity
	pass
	
func execute() -> void:
	current_velocity = lerp(current_velocity, 0, friction)
	var wasd = host.ai.get_wasd_cam() * current_velocity
	host.set_velocity(wasd)
	host.play("Block")
	pass
