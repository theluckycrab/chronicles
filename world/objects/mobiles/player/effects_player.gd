extends State


func _init() -> void:
	index = "Ability Name"
	animation = "Idle"
	priority = 2
	host = null


func enter() -> void:
	pass


func exit() -> void:
	pass


func can_enter() -> bool:
	return true


func can_exit() -> bool:
	return true


func execute() -> void:
	pass
