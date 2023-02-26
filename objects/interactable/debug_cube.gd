extends StaticBody

func interact(target) -> void:
	if target.is_in_group("actors"):
		target.global_transform.origin = $Position3D.global_transform.origin
