class_name Hitbox
extends Area

enum states {GHOST, IDLE, STRIKE, GUARD, PARRY}

enum collision_type {NULL, HIT, GOT_HIT, BLOCKED, GOT_BLOCKED, PARRIED, GOT_PARRIED, CLASH_WON, CLASH_LOST}

var state = states.GHOST
signal hitbox_entered

var collisions = []
var damage = Damage.new()

#Only Strike hitboxes do logic, so everything is from attacker's perspective

func _ready() -> void:
	var _discard = connect("area_entered", self, "on_area_entered")
	
	
func on_area_entered(who) -> void:
	if who.has_method("am_hitbox") and who.get_owner() != get_owner():
		if state != states.GHOST and who.state != states.GHOST:
			if damage.tags.has("Unblockable"):
				if who.state == states.GUARD:
					return
			collisions.append(who)
	
			
func _physics_process(delta):
	if state != states.STRIKE:
		return
	if collisions.empty():
		return
	print(collisions)
	emit_signal("hitbox_entered", self, collisions.front())
	collisions.front().emit_signal("hitbox_entered", collisions.front(), self)
	collisions.clear()
	ghost()
			
			
func idle() -> void:
	self.state = states.IDLE
	
	
func ghost() -> void:
	self.state = states.GHOST
	
	
func reset() -> void:
	self.state = states.GHOST
	
	
func strike() -> void:
	self.state = states.STRIKE
	
	
func guard() -> void:
	self.state = states.GUARD
	
	
func parry() -> void:
	self.state = states.PARRY
	
	
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

static func get_collision_type(mybox, theirbox):
	match mybox.state:
		states.IDLE:
			match theirbox.state:
				states.STRIKE:
					return collision_type.GOT_HIT
		states.STRIKE:
			match theirbox.state:
				states.IDLE:
					return collision_type.HIT
				states.STRIKE:
					return collision_type.CLASH_LOST
				states.GUARD:
					return collision_type.GOT_BLOCKED
				states.PARRY:
					return collision_type.GOT_PARRIED
		states.GUARD:
			match theirbox.state:
				states.STRIKE:
					return collision_type.BLOCKED
		states.PARRY:
			match theirbox.state:
				states.STRIKE:
					return collision_type.PARRIED
	return collision_type.NULL
