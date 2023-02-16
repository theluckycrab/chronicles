extends State

func _init():
	priority = 0
	index = "Idle"

func can_enter() -> bool:
	return host.ai.get_wasd() == Vector3.ZERO
	
func can_exit() -> bool:
	return host.ai.get_wasd() != Vector3.ZERO or ! host.is_on_floor()

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func execute() -> void:
	host.play("Idle")
