extends Projectile

func _init():
	index = "climbing_cyclinder"
	despawn_delay = 30

func _ready():
	$Hitbox.idle()
	var _discard = $Hitbox.connect("hitbox_entered", self, "on_hitbox_entered")
	$Hitbox.owner = self
	
func _physics_process(delta):
	if !is_on_floor():
		move_and_collide(Vector3.DOWN * 9.8)
	
	
func on_hitbox_entered(mybox, theirbox):
	queue_free()
	return

