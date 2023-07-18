extends State

var done = false

func _init():
	priority = 5
	index = "Downed"

func can_enter() -> bool:
	return true
	
func can_exit() -> bool:
	return ! host.armature.is_using_root_motion() and host.is_on_floor() and done

func enter() -> void:
	done = false
	host.play("Downed", true)
	pass
	
func exit() -> void:
	done = false
	host.call_deferred("set_state", "DownedUp")
	pass
	
func execute() -> void:
	host.add_force(Vector3.DOWN * 3)
	pass

func _input(event):
	if !event.is_echo() and event.is_pressed():
		done = true
