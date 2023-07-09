extends Spatial

onready var over_ledge = $Overledge
onready var under_ledge = $Overledge/Underledge
onready var interact = $Interact
onready var ground = $Ground
var lock_target = null

func get_ledge() -> Vector3:
	if ! over_ledge.is_colliding() and under_ledge.is_colliding():
		return under_ledge.get_collision_normal()
	else:
		return Vector3.ZERO
		
func get_interact_target() -> Spatial:
	if interact.is_colliding() and is_instance_valid(interact.get_collider()) and interact.get_collider().has_method("interact"):
		$Interact/Label.text = interact.get_collider().name
		return interact.get_collider()
	else:
		$Interact/Label.text = ""
		return null

func get_grounded():
	if ground.is_colliding():
		return true
	else:
		return false

func get_ground_point():
	if ground.is_colliding():
		return ground.get_collision_point()
	else:
		return Vector3.ZERO
