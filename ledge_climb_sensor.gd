extends Spatial

func get_ledge():
	$Wall.force_raycast_update()
	$Over.force_raycast_update()
	return $Wall.is_colliding() and !$Over.is_colliding()
	
func toggle():
	$Wall.enabled = ! $Wall.enabled
	$Over.enabled = ! $Over.enabled
