class_name Hitbox
extends Area

enum states {GHOST, IDLE, STRIKE, GUARD, PARRY}

var state = states.GHOST

var signals = ["got_hit", "got_blocked", "got_parried", "hit", "parried", "blocked", "clash_lost"]

signal hitbox_entered
signal got_hit
signal got_blocked
signal got_parried
signal hit
signal parried
signal blocked
signal clash_lost

var collisions = []
var damage = Damage.new()
export(int) var damage_amount = 1
export(PoolStringArray) var damage_tags = []

#Only Strike hitboxes do logic, so everything is from attacker's perspective

func _ready() -> void:
	var _discard = connect("area_entered", self, "on_area_entered")
	damage.tags.append_array(damage_tags)
	damage.damage = damage_amount
	set_collision_layer_bit(0, false)
	set_collision_layer_bit(1, true)
	monitoring_off()
	
func on_area_entered(who) -> void:
	collisions.append(who)
	
			
func _physics_process(_delta):
	if state != states.STRIKE:
		return
	if collisions.empty():
		return
	process_collision_list()
			
			
func process_collision_list():
	for i in collisions:
		emit_collision_type(self, i)
		i.emit_collision_type(i, self)
	collisions.clear()
			
			
func idle() -> void:
	self.state = states.IDLE
	monitoring_on()
	
func ghost() -> void:
	self.state = states.GHOST
	monitoring_off()
	
func reset() -> void:
	self.state = states.GHOST
	monitoring_off()
	
func strike() -> void:
	monitoring_on()
	self.state = states.STRIKE
	for i in get_overlapping_areas():
		on_area_entered(i)
	
	
func guard() -> void:
	self.state = states.GUARD
	monitoring_on()
	
	
func parry() -> void:
	self.state = states.PARRY
	monitoring_on()
	
	
func am_hitbox() -> bool:
	return true
	
	
func get_dir(other:Hitbox) -> String:
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
	
	
func emit_collision_type(mybox, theirbox) -> void:
	if !is_instance_valid(mybox) or !is_instance_valid(theirbox):
		return
	match mybox.state:
		states.IDLE:
			match theirbox.state:
				states.STRIKE:
					emit_signal("got_hit", theirbox)
		states.STRIKE:
			match theirbox.state:
				states.IDLE:
					emit_signal("hit", theirbox)
				states.STRIKE:
					emit_signal("clash_lost", theirbox)
				states.GUARD:
					if ! "Unblockable" in damage_tags:
						emit_signal("got_blocked", theirbox)
						collisions.clear()
				states.PARRY:
					if ! "Unblockable" in damage_tags:
						emit_signal("got_parried", theirbox)
						collisions.clear()
		states.GUARD:
			match theirbox.state:
				states.STRIKE:
					emit_signal("blocked", theirbox)
		states.PARRY:
			match theirbox.state:
				states.STRIKE:
					emit_signal("parried", theirbox)
	return

func monitoring_on():
	monitorable = true
	monitoring = true
	
func monitoring_off():
	monitorable = false
	monitoring = false
	
func Connect(who):
	for i in signals:
		var _discard = connect(i, who, "on_"+i)
