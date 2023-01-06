extends Spatial

onready var step = $Step
onready var over = $Over

func get_step():
	return step.is_colliding() and !over.is_colliding()
