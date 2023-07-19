extends State

func _init():
	priority = 500
	index = "Dead"

func can_enter() -> bool:
	return true
	
func can_exit() -> bool:
	return false

func enter() -> void:
	host.play("Downed", true)
	pass
	
func exit() -> void:
	pass
	
func execute() -> void:
	host.add_force(Vector3.DOWN * 30)
	pass
