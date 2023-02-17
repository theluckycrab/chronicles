extends Spatial

func get_ledge():
	if ! $Overledge.is_colliding() and $Overledge/Underledge.is_colliding():
		return $Overledge/Underledge.get_collision_normal()
	else:
		return Vector3.ZERO
