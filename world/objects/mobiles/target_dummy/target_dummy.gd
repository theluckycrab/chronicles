extends KinematicBody

var net_stats = NetStats.new("target_dummy")

func _ready():
	net_stats.netID = Network.nid_gen()
	$Guardbox.reset()
	var _discard = $Hitbox.connect("hitbox_entered", self, "on_hitbox_entered")
	
func on_hitbox_entered(_mybox, theirbox):
	if theirbox.state == "Strike":
		print(name, " was struck!")

func lock_on() -> void:
	pass
