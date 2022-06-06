extends PlayerMoveState

var dir = "Front"

func _init() -> void:
	index = "Guard"
	animation = "Guard_Forward"
	priority = 1
	host = null


func controls():
	dir = get_dir()
	animation = "Guard_"+dir
	
	
func enter() -> void:
	controls()
	host.guard(get_dir())
	pass
	
	
func exit() -> void:
	host.guard_reset()
	pass
	
	
func can_exit() -> bool:
	return host.get_animation() != animation
	
	
func can_enter() -> bool:
	return true
	
	
func execute() -> void:
	if Input.is_action_just_released("guard"):
		get_parent().quit_state()
	pass

func get_dir() -> String:
	var vel = Vector3.ZERO
	vel.x = Input.get_action_strength("d") - Input.get_action_strength("a")
	vel.y = Input.get_action_strength("s") - Input.get_action_strength("w")
	match vel.abs().max_axis():
		Vector3.AXIS_Y:
			if vel.y < 0:
				return "Above"
		Vector3.AXIS_X:
			if vel.x > 0:
				return "Right"
			if vel.x < 0:
				return "Left"
	return "Forward"
