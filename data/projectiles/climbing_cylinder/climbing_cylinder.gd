extends Projectile

func _init():
	index = "climbing_cyclinder"
	despawn_delay = 30

func _ready():
	$Hitbox.idle()
	var _discard = $Hitbox.connect("hitbox_entered", self, "on_hitbox_entered")
	$Hitbox.owner = self
	var view = get_viewport()
	get_parent().remove_child(self)
	view.add_child(self)
	
func _physics_process(_delta):
	if !is_on_floor():
		var _discard = move_and_collide(Vector3.DOWN * 9.8)
	
	
func on_hitbox_entered(_mybox, _theirbox):
	queue_free()
	return

