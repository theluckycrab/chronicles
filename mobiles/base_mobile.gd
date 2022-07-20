extends KinematicBody

func _physics_process(delta):
	move_and_slide(Vector3.DOWN * 5, Vector3.UP)
