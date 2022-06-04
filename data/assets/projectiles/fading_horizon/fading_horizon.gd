extends Projectile

func _init():
	despawn_delay = 0.1

func _ready():
	var _dicksard = $Hitbox.connect("hitbox_entered", self, "on_hitbox_entered")
	
func on_hitbox_entered(mybox, theirbox):
	print(mybox, "fading horizoned ", theirbox)
