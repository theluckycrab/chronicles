extends KinematicBody

var net_stats = NetStats.new("target_dummy")
var damagers = []
var hp = 100

func _ready():
	$Guardbox.guard("Above")
	net_stats.netID = Network.nid_gen()
	var _discard = $Hitbox.connect("hitbox_entered", self, "on_hitbox_entered")
	$Hitbox.idle()
	
func _physics_process(_delta):
	process_damagers()
	
func on_hitbox_entered(mybox, theirbox):
	if theirbox.state == Hitbox.states.STRIKE:
		if !damagers.has(theirbox):
			damagers.append(theirbox)

func lock_on() -> void:
	pass

func process_damagers():
	for i in damagers:
		hp -= i.damage.damage
		print(name, " took ", i.damage.damage, " damage from ", i)
		print(hp, " hp remains")
	damagers.clear()
	
