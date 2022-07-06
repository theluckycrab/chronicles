extends PlayerMoveState

var start = false

func _init() -> void:
	index = "Fall"
	animation = "Fall"
	priority = 1
	host = null


func enter() -> void:
	yield(get_tree().create_timer(0.35), "timeout")
	start = true
	pass
	
	
func exit() -> void:
	start = false
	pass
	
	
func can_exit() -> bool:
	return host.is_on_floor()
	
	
func can_enter() -> bool:
	return !host.is_on_floor()
	
	
func execute() -> void:
	if Input.is_action_just_pressed("light_attack"):
		host.set_state("falling_attack")
	host.add_force(host.get_wasd_cam() * 10.5)
	if !start:
		host.add_force(Vector3.UP * 1)
	pass
