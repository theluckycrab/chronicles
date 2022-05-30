class_name Hitbox
extends Area

signal hitbox_entered

export var state = "Idle"

func _ready():
	connect("area_entered", self, "on_area_entered")
	
func on_area_entered(who):
	if state != "Ghost":
		if who.has_method("am_hitbox") and who.get_owner() != get_owner():
			emit_signal("hitbox_entered", self, who)
			
func idle():
	state = "Idle"
	
func ghost():
	state = "Ghost"
	
func reset():
	state = "Ghost"
	
func strike():
	state = "Strike"
		
func guard():
	state = "Guard"
		
func am_hitbox():
	return true

func get_dir(other):
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
