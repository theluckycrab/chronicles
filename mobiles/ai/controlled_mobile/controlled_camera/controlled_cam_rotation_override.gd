extends Camera


func _get(property):
	match property:
		"rotation":
			return Vector3(get_parent().rotation.x, get_parent().get_parent().rotation.y, get_parent().rotation.z)
