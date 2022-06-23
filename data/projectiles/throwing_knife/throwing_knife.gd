extends Projectile

signal got_blocked
signal blocked
signal hit
signal got_parried
signal parried

func _init():
	index = "throwing_knife_projectile"
	despawn_delay = 2

func _ready():
	$Hitbox.strike()
	var _discard = $Hitbox.connect("hitbox_entered", self, "on_hitbox_entered")
	
func on_hitbox_entered(mybox, theirbox):
	match Hitbox.get_collision_type(mybox, theirbox):
		Hitbox.collision_type.GOT_BLOCKED:
			emit_signal("got_blocked", mybox, theirbox)
		Hitbox.collision_type.BLOCKED:
			emit_signal("blocked", mybox, theirbox)
		Hitbox.collision_type.HIT:
			emit_signal("hit", mybox, theirbox)
		Hitbox.collision_type.GOT_PARRIED:
			emit_signal("got_parried", mybox, theirbox)
		Hitbox.collision_type.PARRIED:
			emit_signal("parried", mybox, theirbox)
	return

func _physics_process(_delta):
	var dir = Vector3.BACK.rotated(Vector3.UP, rotation.y)
	var _discard = move_and_slide(dir * 15)
