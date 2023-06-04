extends State

var done = false

func _init():
	priority = 3
	index = "Debug"

func can_enter() -> bool:
	return true
	
func can_exit() -> bool:
	return Input.is_action_just_released("debug") and done

func enter() -> void:
	host.play("Sit")
	yield(get_tree().create_timer(1), "timeout")
	done = true
	
func exit() -> void:
	done = false
	pass
	
func execute() -> void:
	var wasd = host.ai.get_wasd()
	wasd = wasd.normalized().rotated(Vector3.UP, get_viewport().get_camera().rotation.y)
	host.set_velocity(wasd * 100)
	host.add_force(Vector3.UP)
	if Input.is_action_pressed("jump"):
		host.add_force(Vector3.UP * 30)
	elif Input.is_action_pressed("strong"):
		host.add_force(Vector3.DOWN * 30)
