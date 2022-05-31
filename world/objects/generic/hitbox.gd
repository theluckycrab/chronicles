class_name Hitbox
extends Area

export var state = "Idle"
signal hitbox_entered


func _ready() -> void:
	var _discard = connect("area_entered", self, "on_area_entered")
	
	
func on_area_entered(who) -> void:
	if state != "Ghost":
		if who.has_method("am_hitbox") and who.get_owner() != get_owner():
			emit_signal("hitbox_entered", self, who)
			
			
func idle() -> void:
	state = "Idle"
	
	
func ghost() -> void:
	state = "Ghost"
	
	
func reset() -> void:
	state = "Ghost"
	
	
func strike() -> void:
	state = "Strike"
	
	
func guard() -> void:
	state = "Guard"
	
	
func am_hitbox() -> bool:
	return true
	
	
func get_dir(other) -> String:
	var pos = global_transform.origin
	var opos = other.global_transform.origin
	var dir = pos.direction_to(opos)
	match dir.max_axis():
		Vector3.AXIS_X:
			if dir.x > 0:
				return "right"
			elif dir.x < 0:
				return "left"
		Vector3.AXIS_Y:
			if dir.y > 0:
				return "up"
			elif dir.y < 0:
				return "down"
		Vector3.AXIS_Z:
			if dir.z > 0:
				return "front"
			elif dir.z < 0:
				return "behind"
	print(self, " unable to determine direction of ", other)
	return "front"
